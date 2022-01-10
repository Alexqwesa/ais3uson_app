// ignore_for_file: prefer_final_fields, flutter_style_todos

import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global singleton class.
///
/// It store some global data, like:
/// - [hiveData] of type [Hive],
/// - [profiles] of type [WorkerProfile].
///
/// It save/restore hive and notifies listeners.
// ignore: prefer_mixin
class AppData with ChangeNotifier {
  /// Store Singleton
  static late final SharedPreferences prefs;
  static final AppData _instance = AppData._internal();

  /// Global Storage [hiveData]
  late Box hiveData;

  late ScreenArguments lastScreen;

  final standardTheme = StandardTheme();

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
    hiveData
      ..compact()
      ..close();
    // maybe don't dispose of singleton?
    super.dispose();
  }

  /// Post init
  ///
  /// read setting from hive, and sync
  Future<void> postInit() async {
    ScreenArguments(profile: 0);
    prefs = await SharedPreferences.getInstance();
    for (final Map<dynamic, dynamic> keyFromHive
        in jsonDecode(prefs.getString('WorkerKeys') ?? '[]')) {
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

  Future<bool> save() async {
    return prefs.setString(
      'WorkerKeys',
      jsonEncode(workerKeys.map((e) => e.toJson()).toList()),
    );
  }

  Future<bool> addProfileFromUKey(WorkerKey key) async {
    if (_profiles.firstWhereOrNull((element) => element.key == key) == null) {
      _profiles.add(WorkerProfile(key));
      await save();
      notifyListeners();

      return true;
    }

    return false;
  }
}
