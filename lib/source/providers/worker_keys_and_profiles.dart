import 'dart:convert';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of user authentication data,
///
/// Read/save from/to SharedPreferences, had default value [].
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final workerKeys =
    StateNotifierProvider<WorkerKeysState, List<WorkerKey>>((ref) {
  return WorkerKeysState();
});

class WorkerKeysState extends StateNotifier<List<WorkerKey>> {
  static const name = 'WorkerKeys2';

  @override
  set state(List<WorkerKey> value) {
    super.state = value;
    //
    // > save
    //
    locator<SharedPreferences>()
        .setString(name, jsonEncode(value.map((e) => e.toJson()).toList()))
        .then((res) {
      if (!res) {
        showErrorNotification(
          'Ошибка: не удалось сохранить профиль отделения!',
        );
      }
    });
  }

  WorkerKeysState()
      // ignore: avoid_dynamic_calls
      : super((jsonDecode(locator<SharedPreferences>().getString(name) ?? '[]')
                .map<WorkerKey>(
          // ignore: avoid_annotating_with_dynamic
          (dynamic e) => WorkerKey.fromJson(e as Map<String, dynamic>),
        ) as Iterable<WorkerKey>)
            .toList(),);

  /// Add [WorkerKey].
  ///
  /// Check for duplicates before addition.
  bool addKey(WorkerKey key) {
    if (state.contains(key)) return false;
    state = [...state, key];

    return true;
  }

  /// Delete [WorkerKey].
  void deleteAt(int index) {
    state = [...(state..removeAt(index))];
  }
}

/// Provider of List<[WorkerProfile]>.
///
/// Show profiles based on [workerKeys].
///
/// {@category Providers}
final workerProfiles =
    StateNotifierProvider<WorkerProfilesState, List<WorkerProfile>>((ref) {
  return WorkerProfilesState(ref); //, ref.watch(workerKeys));
});

class WorkerProfilesState extends StateNotifier<List<WorkerProfile>> {
  final StateNotifierProviderRef ref;

  WorkerProfilesState(this.ref) // , List<WorkerKey> wKeys
      : super(<WorkerProfile>[]) {
    sync(ref.read(workerKeys));
    ref.listen(workerKeys, (previous, next) {
      sync((next ?? <WorkerKey>[]) as List<WorkerKey>);
    });
  }

  void sync(List<WorkerKey> wKeys) {
    final newState = <WorkerProfile>[];
    final keySet = <WorkerKey>{};
    for (final wp in state) {
      if (wKeys.contains(wp.key)) {
        newState.add(wp);
        keySet.add(wp.key);
      }
    }
    wKeys.where((element) => !keySet.contains(element)).forEach((key) {
      newState.add(WorkerProfile(key, ref.container));
    });
    state = newState;
  }

  void addProfileFromKey(WorkerKey key) {
    if (!ref.read(workerKeys).contains(key)) {
      ref.read(workerKeys.notifier).addKey(key);
    }
  }

  /// Delete [WorkerProfile].
  void profileDelete(WorkerKey key) {
    final index =
        state.indexOf(state.firstWhere((element) => element.key == key));
    final wp = state[index];
    final apiKey = key.apiKey;
    state = [...(state..removeAt(index))];
    wp.dispose();
    Hive
      ..deleteBoxFromDisk('archiveDates_$apiKey')
      ..deleteBoxFromDisk('journal_archive_$apiKey');
  }
}

/// Simple provider for archive view, based on [workerProfiles].
///
/// {@category Providers}
final archiveWorkerProfiles = StateProvider<List<WorkerProfile>>((ref) {
  return ref
      .watch(workerProfiles)
      .map((e) => e.copyWith(archiveDate: ref.watch(archiveDate)))
      .toList();
});
