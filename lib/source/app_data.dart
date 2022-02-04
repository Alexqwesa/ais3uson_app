// ignore_for_file: prefer_final_fields, flutter_style_todos

import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
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

  final standardTheme = StandardTheme();

  /// Global Storage [hiveData]
  late Box hiveData;

  late ScreenArguments lastScreen;

  http.Client httpClient = http.Client();

  List<WorkerProfile> _realProfiles = [];
  List<WorkerProfile> _archiveProfiles = [];

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

  /// Factory to construct singleton.
  factory AppData() => _instance; // ??= AppData._internal();
  AppData._internal();

  /// Show is active [_profiles] list had [WorkerProfile]s with real [Journal],
  /// or with [JournalArchive].
  bool _isArchive = false;

  bool get isArchive => _isArchive;

  set isArchive(bool newValue) {
    if (newValue == _isArchive) {
      return;
    } else {
      if (_isArchive) {
        _profiles = _realProfiles;
      } else {
        // if (_archiveProfiles.length == profiles.length) { //todo more checks
        //   _profiles = _archiveProfiles;
        // }
        _realProfiles = _profiles;
        _profiles = _profiles.map((e) {
          return WorkerProfile(e.key, archiveDate: DateTime.now());
        }).toList();
        _archiveProfiles = _profiles;
      }

      _isArchive = newValue;
    }
  }

  @override
  void dispose() {
    asyncDispose();
    super.dispose();
  }

  /// Wait till all Hive boxes are closed
  Future<void> asyncDispose() async {
    if (AppData().hiveData.isOpen) {
      await AppData().hiveData.close();
    }
    await Future.wait(AppData().profiles.map((el) async {
      if (el.journal.hive.isOpen) {
        await el.journal.hive.close();
      }
      if (el.journal.hiveArchive.isOpen) {
        await el.journal.hiveArchive.close();
      }
    }));
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
    await Future.wait(_profiles.map((e) => e.postInit()));
    notifyListeners();
  }

  Future<void> save() async {
    final res = await prefs.setString(
      'WorkerKeys',
      jsonEncode(workerKeys.map((e) => e.toJson()).toList()),
    );
    if (!res) {
      showErrorNotification('Ошибка: не удалось сохранить профиль отделения!');
    }
    notifyListeners();
  }

  /// Add Profile from [WorkerKey].
  ///
  /// Check for duplicates before addition, save and notify listeners.
  Future<bool> addProfileFromKey(WorkerKey key) async {
    if (_profiles
            .firstWhereOrNull((element) => element.key.apiKey == key.apiKey) ==
        null) {
      final wp = WorkerProfile(key);
      _profiles.add(wp);
      await save();
      notifyListeners();
      await wp.postInit();
      notifyListeners();

      return true;
    }

    return false;
  }
}
