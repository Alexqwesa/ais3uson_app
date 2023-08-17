// ignore_for_file: sort_constructors_first

import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'departments.g.dart';

/// Provider and controller of List<[WorkerProfile]>.
///
/// Add, save, delete and load [WorkerProfile].
/// which are saved by [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category Controllers}
@Riverpod(keepAlive: true)
class Departments extends _$Departments {
  static const name = 'WorkerKeys2';

  final _stubWorker = WorkerProfile(
      WorkerKey.fromJson(
        jsonDecode(stubJsonWorkerKey) as Map<String, dynamic>,
      ),
      null);

  /// Just keys of [WorkerProfile]s
  Iterable<WorkerKey> get keys => state.map((e) => e.key);

  List<String> _shortNames = [];

  @override
  List<WorkerProfile> build() {
    final json = jsonDecode(
      locator<SharedPreferences>().getString(name) ?? '[]',
    );
    if (json is List) {
      final keys =
          json.whereType<Map<String, dynamic>>().map(WorkerKey.fromJson);
      super.state = keys.map((key) => WorkerProfile(key, ref)).toList();
      _updateShortNames();
      return super.state;
    }
    return [];
  }

  void _updateShortNames({int length = 7}) {
    _shortNames = [
      for (final wk in keys) wk.apiKey.hashCode.toString().substring(0, length)
    ];
    if (_shortNames.length != _shortNames.toSet().length) {
      _updateShortNames(length: length + 2);
    }
  }

  /// Each [WorkerProfile] identified by its apiKey,
  /// but it should be keep secure, and it can be long.
  /// [shortNames] generated from apiKey, for navigation purposes.
  List<String> get shortNames {
    if (_shortNames.isEmpty) _updateShortNames();
    return _shortNames;
  }

  /// Get [WorkerProfile] by shortName
  WorkerProfile operator [](String? name) {
    if (name == null) {
      return _stubWorker;
    }

    if (_shortNames.length != state.length) _updateShortNames();

    final index = _shortNames.indexOf(name);
    if (index < 0) {
      return _stubWorker;
    }

    return state[index];
  }

  @override
  set state(List<WorkerProfile> value) {
    super.state = value;
    _updateShortNames();
    //
    // > save
    //
    locator<SharedPreferences>()
        .setString(name, jsonEncode(value.map((e) => e.key.toJson()).toList()))
        .onError((error, stackTrace) => false)
        .then((res) {
      if (!res) {
        showErrorNotification(
          tr().errorDepSave,
        );
      }
    });
  }

  // /// Get [WorkerKey] by apiKey.
  // WorkerKey key(String apiKey) =>
  //     state.firstWhere((e) => e.apiKey == apiKey).key;

  bool addProfileFromKey(WorkerKey key) {
    if (!keys.contains(key)) {
      state = [...state, WorkerProfile(key, ref)];
      return true;
    }

    return false;
  }

  /// Delete [WorkerProfile].
  void profileDelete(WorkerKey key) {
    state = state.whereNot((e) => e.apiKey == key.apiKey).toList();
  }

  /// Each [WorkerProfile] identified by its apiKey,
  /// but it should be keep secure, and it can be long.
  /// [shortNames] generated from apiKey, for navigation purposes.
  String getShortNameByApi(String apiKey) {
    _updateShortNames();
    return _shortNames[state.indexOf(
      state.firstWhere((e) => e.apiKey == apiKey),
    )];
  }
}
