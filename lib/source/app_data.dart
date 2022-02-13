// ignore_for_file: flutter_style_todos

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer' as dev;

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

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
  late final SharedPreferences prefs;

  final standardTheme = StandardTheme();

  /// Global Storage [hiveData]
  late Box hiveData;

  late ScreenArguments lastScreen;

  http.Client httpClient = http.Client();

  /// View of services List, can be: ['', 'tile', 'short']
  String serviceView = '';

  // ignore: prefer_constructors_over_static_methods
  static AppData get instance => AppData();

  List<WorkerProfile> get profiles => _profiles;

  String get apiKey => profiles.first.key.apiKey;

  /// workerKeys - is user authentication data,
  Iterable<WorkerKey> get workerKeys => _profiles.map((e) => e.key);

  bool get isArchive => _isArchive;

  DateTime get archiveDate => _archiveDate;

  set archiveDate(DateTime? newValue) {
    _archiveDate = newValue ?? _archiveDate;
    notifyListeners();
  }

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
        // _archiveProfiles = _profiles;
      }

      _isArchive = newValue;
      notifyListeners();
    }
  }

  /// Show is active [_profiles] list had [WorkerProfile]s with real [Journal],
  /// or with [JournalArchive].
  bool _isArchive = false;

  List<WorkerProfile> _realProfiles = [];

  // List<WorkerProfile> _archiveProfiles = [];

  var _archiveDate = DateTime.now().add(const Duration(days: -1));

  /// Profiles list
  List<WorkerProfile> _profiles = [];

  /// Factory to construct singleton.
  factory AppData() {
    try {
      return Singleton.get<AppData>();
      // ignore: avoid_catching_errors
    } on UnimplementedError {
      Singleton.register(AppData._internal());
    }

    return Singleton.get<AppData>();
  }

  AppData._internal();

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

    await prefs.setString('serviceView', serviceView);
  }

  /// Init Hive and its adapters.
  ///
  /// Read setting from [SharedPreferences], Hive and and call [WorkerProfile.postInit]s.
  Future<void> postInit() async {
    //
    // > Init Hive
    //
    try {
      // never fail on double adapter registration
      Hive
        ..registerAdapter(ServiceOfJournalAdapter())
        ..registerAdapter(ServiceStateAdapter());
      // ignore: avoid_catching_errors
    } on HiveError catch (e) {
      dev.log(e.toString());
    }
    hiveData = await Hive.openBox<dynamic>('profiles');
    //
    // > Init WorkerProfiles
    //
    ScreenArguments(profile: 0);
    prefs = await SharedPreferences.getInstance();
    for (final Map<dynamic, dynamic> keyFromHive
        in jsonDecode(prefs.getString('WorkerKeys') ?? '[]')) {
      _profiles.add(
        WorkerProfile(WorkerKey.fromJson(keyFromHive.cast<String, dynamic>())),
      );
    }
    serviceView = prefs.getString('serviceView') ?? '';
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
    await prefs.setString('serviceView', serviceView);
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
      _realProfiles.add(wp);
      notifyListeners();
      await save();
      await wp.postInit();
      notifyListeners();

      return true;
    }

    return false;
  }

  /// Calculate size of [ServiceCard]. It is calculated here because it used in different places.
  Size serviceCardSize(Size parentSize) {
    final parentWidth = parentSize.width;
    if (serviceView == 'tile') {
      final divider = (parentWidth - 20) ~/ 400.0;
      final cardWidth = parentWidth / divider;

      return Size(
        cardWidth * 1.0,
        cardWidth / 4,
      );
    } else {
      var divider = (parentWidth - 20) ~/ 250.0;
      divider = divider > 1 ? divider : 2;
      final cardWidth = parentWidth / divider;

      return Size(
        cardWidth * 1.0,
        cardWidth * 1.2,
      );
    }
  }

  /// Just delete profile, notify and save left profiles.
  void profileDelete(int index) {
    _profiles.removeAt(index);
    notifyListeners();
    unawaited(AppData().save());
  }
}
