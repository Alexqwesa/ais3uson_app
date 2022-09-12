// ignore_for_file: sort_constructors_first

import 'dart:convert';

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider and controller of List<[WorkerProfile]>.
///
/// Add, save, delete and load [WorkerProfile].
/// Show profiles based on [_workerKeys], which is saved by
/// [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category Controllers}
final workerProfiles =
    StateNotifierProvider<_WorkerProfilesState, List<WorkerProfile>>((ref) {
  return _WorkerProfilesState(ref); //, ref.watch(workerKeys));
});

class _WorkerProfilesState extends StateNotifier<List<WorkerProfile>> {
  _WorkerProfilesState(this.ref) // , List<WorkerKey> wKeys
      : super(<WorkerProfile>[]) {
    sync(ref.read(_workerKeys));
    ref.listen(_workerKeys, (previous, next) {
      sync((next ?? <WorkerKey>[]) as List<WorkerKey>);
    });
  }

  final StateNotifierProviderRef ref;

  /// Get [WorkerKey] by apiKey.
  WorkerKey key(String apiKey) =>
      ref.read(_workerKeys).firstWhere((e) => e.apiKey == apiKey);

  void sync(List<WorkerKey> wKeys) {
    final newState = <WorkerProfile>[];
    final keySet = <WorkerKey>{};
    // keep exists if they are in wKeys
    for (final wp in state) {
      try {
        if (wKeys.contains(wp.key)) {
          newState.add(wp);
          keySet.add(wp.key);
        }
        // ignore: avoid_catching_errors
      } on StateError {
        // we can't access wp.key of deleted department
      }
    }
    // add new
    wKeys.where((element) => !keySet.contains(element)).forEach((key) {
      newState.add(WorkerProfile(key.apiKey, ref.container));
    });
    state = newState;
  }

  bool addProfileFromKey(WorkerKey key) {
    if (!ref.read(_workerKeys).contains(key)) {
      return ref.read(_workerKeys.notifier).addKey(key);
    }

    return false;
  }

  /// Delete [WorkerProfile].
  void profileDelete(WorkerKey key) {
    ref.read(_workerKeys.notifier).state = ref
        .read(_workerKeys)
        .whereNot((element) => element.apiKey == key.apiKey)
        .toList();
    // Todo: cleanup deleted profiles (on exit?)
    // final apiKey = key.apiKey;
    // final index =
    //     state.indexOf(state.firstWhere((element) => element.key == key));
    // final wp = state[index];
    // state = state.whereNot((element) => element.key != key).toList();
    // Hive
    //   ..deleteBoxFromDisk(wp.hiveName)
    //   ..deleteBoxFromDisk('archiveDates_$apiKey')
    //   ..deleteBoxFromDisk('journal_archive_$apiKey');
  }
}

/// Provider of user authentication data,
///
/// Read/save from/to SharedPreferences, had default value [].
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final _workerKeys =
    StateNotifierProvider<_WorkerKeysState, List<WorkerKey>>((ref) {
  return _WorkerKeysState();
});

class _WorkerKeysState extends StateNotifier<List<WorkerKey>> {
  _WorkerKeysState()
      : super(
          // ignore: avoid_dynamic_calls
          (jsonDecode(locator<SharedPreferences>().getString(name) ?? '[]')
                  .map<WorkerKey>(
            // ignore: avoid_annotating_with_dynamic
            (dynamic e) => WorkerKey.fromJson(e as Map<String, dynamic>),
          ) as Iterable<WorkerKey>)
              .toList(),
        );

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
          tr().errorDepSave,
        );
      }
    });
  }

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
