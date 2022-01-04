// ignore_for_file: prefer_final_fields, flutter_style_todos

import 'dart:async';
import 'dart:core';

import 'package:ais3uson_app/src/data_classes/from_json/worker_key.dart';
import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Global AppData
///
/// global singleton class
/// for storing global data
/// and notifies listeners
// ignore: prefer_mixin
class AppData with ChangeNotifier {
  /// Store Singleton
  static late final AppData _instance = AppData._internal();

  /// Global Storage [hiveData]
  late Box hiveData;

  late ScreenArguments lastScreen; // = ScreenArguments(profile: 0);

  static AppData get instance => _instance; // ??= AppData._internal();

  List<WorkerProfile> get profiles => _profiles;

  String get apiKey => profile.key.apiKey;

  /// workerKeys - is user authentication data,
  Iterable<WorkerKey> get workerKeys => _profiles.map((e) => e.key);

  /// Get first profile with working server
  WorkerProfile get profile {
    // TODO:
    // if (_profiles.first.connection_ok){
    return _profiles.first;
  }

  /// Profiles list
  List<WorkerProfile> _profiles = [];

  /// Constructor
  ///
  /// just constructor and singleton
  factory AppData() => _instance; // ??= AppData._internal();
  AppData._internal();

  @override
  void dispose() {
    // TODO:
    // hiveData.compact();
    // hiveData.close();
    // Don't dispose of singleton
    // super.dispose();
  }

  /// Post init
  ///
  /// read setting from hive, and sync
  void postInit() {
    ScreenArguments(profile: 0);

    for (final Map<dynamic, dynamic> keyFromHive in hiveData.get(
      'WorkerKeys',
      defaultValue: <Map<String, dynamic>>[],
    )) {
      _profiles.add(
        WorkerProfile(WorkerKey.fromJson(keyFromHive.cast<String, dynamic>())),
      );
    }
    notifyListeners();
  }

  void notify() {
    // is it needed?
    notifyListeners();
  }

  Future<bool> addProfileFromUKey(WorkerKey key) async {
    if (_profiles.firstWhereOrNull((element) => element.key == key) == null) {
      _profiles.add(WorkerProfile(key));
      await hiveData.put(
        'WorkerKeys',
        workerKeys.map((e) => e.toJson()).toList(),
      );
      notifyListeners();

      return true;
    }

    return false;
  }
}
