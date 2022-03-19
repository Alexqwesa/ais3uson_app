// ignore_for_file: flutter_style_todos

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer' as dev;

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
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

/// Global singleton class.
///
/// It store some global data, like:
/// - [hiveData] of type [Hive],
/// - [profiles] of type [WorkerProfile].
///
/// It save/restore hive and notifies listeners.
// ignore: prefer_mixin
class AppData with ChangeNotifier {
  final standardTheme = StandardTheme();

  /// Global Storage [hiveData]
  late Box hiveData;

  SharedPreferences? prefs;

  late ScreenArguments lastScreen;

  http.Client httpClient = http.Client();

  int hiveArchiveLimit = 3000;  // maybe use months?

  /// Dates which have archived services
  Set<DateTime> datesInArchive = <DateTime>{};

  ClientProfile? lastClient;
  WorkerProfile? lastWorker;

  bool inited = false;

  // ignore: prefer_constructors_over_static_methods
  static AppData get instance => AppData();

  String get serviceView => _serviceView;

  set serviceView(String value) {
    _serviceView = value;

    unawaited(prefs?.setString('serviceView', serviceView));
  }

  List<WorkerProfile> get profiles => _profiles;

  /// workerKeys - is user authentication data,
  Iterable<WorkerKey> get workerKeys => _profiles.map((e) => e.key);

  /// Is displayed usual view of App or archive view
  bool get isArchive => _isArchive;

  /// When app is in [isArchive] mode it will display this date.
  DateTime get archiveDate {
    if (_archiveDate == null) {
      final dt = DateTime.now().add(const Duration(days: -1));
      _archiveDate = DateTime(dt.year, dt.month, dt.day);
    }

    return _archiveDate!;
  }

  /// This value can be set only from [isArchive], then _archiveDate is already inited.
  set archiveDate(DateTime? newValue) {
    _archiveDate = newValue ?? _archiveDate;
    //
    // > just reinit [JournalArchive]
    //
    _profiles.forEach((w) async {
      (w.journal as JournalArchive).aDate = archiveDate;
      await w.journal.postInit();
    });
    notifyListeners();
  }

  set isArchive(bool newValue) {
    if (newValue == _isArchive) {
      return;
    } else {
      if (_isArchive) {
        _profiles = _realProfiles;
      } else {
        //
        // > create and init new profiles
        //
        _realProfiles = _profiles;
        _profiles = _profiles.map((e) {
          return WorkerProfile(e.key, archiveDate: archiveDate);
        }).toList();
        profiles.forEach((element) {
          element.postInit();
        });
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

  DateTime? _archiveDate;

  /// View of services List, can be: '', 'tile', 'short'
  String _serviceView = '';

  /// Profiles list
  List<WorkerProfile> _profiles = [];

  AppData();

  @override
  void dispose() {
    asyncDispose();
    super.dispose();
  }

  /// Wait till all Hive boxes are closed
  Future<void> asyncDispose() async {
    if (locator<AppData>().hiveData.isOpen) {
      await locator<AppData>().hiveData.close();
    }
    await Future.wait(locator<AppData>().profiles.map((el) async {
      if (el.journal.hive.isOpen) {
        await el.journal.hive.close();
      }
      if (el.journal.hiveArchive.isOpen) {
        await el.journal.hiveArchive.close();
      }
    }));

    await prefs?.setString('serviceView', serviceView);

    _profiles = [];
    inited = false;
  }

  /// Init Hive and its adapters.
  ///
  /// Read setting from [SharedPreferences], Hive and and call [WorkerProfile.postInit]s.
  Future<void> postInit() async {
    //
    // > Init Hive
    //
    if (inited) {
      return;
    }
    inited = true;
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
        in jsonDecode(prefs!.getString('WorkerKeys2') ?? '[]')) {
      _profiles.add(
        WorkerProfile(WorkerKey.fromJson(keyFromHive.cast<String, dynamic>())),
      );
    }
    serviceView = prefs!.getString('serviceView') ?? '';
    hiveArchiveLimit = prefs!.getInt('hiveArchiveLimit') ?? 1000;
    notifyListeners();
    await Future.wait(_profiles.map((e) => e.postInit()));
    notifyListeners();
    unawaited(() async {
      datesInArchive.addAll(
        workerKeys
            //
            // > get values from hive
            //
            .map<dynamic>(
              (e) => hiveData.get(
                'archiveDates_${e.apiKey}',
                defaultValue: <DateTime>[],
              ),
            )
            //
            // > just type cast
            //
            // ignore: avoid_annotating_with_dynamic
            .expand<dynamic>((dynamic element) => element as Iterable<dynamic>)
            // ignore: avoid_annotating_with_dynamic
            .map<DateTime>((dynamic e) => e as DateTime)
            .map((e) => DateTime(e.year, e.month, e.day)), // not necessary
      );
    }());
  }

  Future<void> save() async {
    final res = await prefs?.setString(
      'WorkerKeys2',
      jsonEncode(workerKeys.map((e) => e.toJson()).toList()),
    );
    if (res == null || !res) {
      showErrorNotification('Ошибка: не удалось сохранить профиль отделения!');
    }
    notifyListeners();
    await prefs?.setString('serviceView', serviceView);
    await prefs?.setString('WorkerKeys', ''); // cleanup old data
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
      var cardWidth = (parentWidth / divider) - 10;
      if (divider == 0) {
        cardWidth = (parentWidth - 10).abs();
      }

      return Size(
        cardWidth * 1.0,
        cardWidth / 4,
      );
    } else if (serviceView == 'square') {
      var divider = (parentWidth - 20) ~/ 150.0;
      if (parentWidth < 130) {
        divider = 1;
      } else if (parentWidth < 260) {
        divider = 2;
      } else {
        divider = divider > 2 ? divider : 3;
      }
      final cardWidth = parentWidth / divider;

      return Size(
        cardWidth,
        cardWidth,
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

  /// Just delete profile, notify and save remain profiles.
  void profileDelete(int index) {
    hiveData
        .delete('archiveDates_${_profiles[index].apiKey}')
        .then((value) => unawaited(locator<AppData>().save()));
    unawaited(
      Hive.deleteBoxFromDisk('journal_archive_${_profiles[index].apiKey}'),
    );
    _profiles.removeAt(index);
    notifyListeners();
    unawaited(locator<AppData>().save());
  }

  Future<ClientProfile?> getLastClient() async {
    await postInit();
    var returnLastClient = lastClient;
    if (returnLastClient == null) {
      final worker = await getLastWorker();
      if (worker != null) {
        lastClient = getClientByContractId(worker, prefs?.getInt('contractId'));
      }
    }
    returnLastClient = lastClient;

    return Future(() async => returnLastClient);
  }

  /// Find client in [WorkerProfile] by [ClientProfile.contractId] or return first, or null.
  ClientProfile? getClientByContractId(WorkerProfile workerProfile, int? cId) {
    if (workerProfile.clients.isNotEmpty) {
      for (final client in workerProfile.clients) {
        if (client.contractId == cId) {
          return client;
        }
      }
    }

    return null;
  }

  WorkerProfile? getWorkerByApiKey(String? key) {
    if (key != null) {
      for (final w in profiles) {
        if (w.apiKey == key) {
          return w;
        }
      }
    }

    return null;
  }

  Future<WorkerProfile?> getLastWorker() async {
    await postInit();
    var returnLast = lastWorker;
    if (returnLast == null) {
      lastWorker = getWorkerByApiKey(prefs?.getString('WorkerApiKey'));
      returnLast = lastWorker;
    }
    if (returnLast == null && profiles.isNotEmpty) {
      lastWorker = profiles.first;
      returnLast = lastWorker;
    }

    return Future(() async => returnLast);
  }

  Future<bool> setLastWorker(WorkerProfile wp) async {
    lastWorker = wp;

    return prefs!.setString('WorkerApiKey', wp.apiKey);
  }

  Future<bool> setLastClient(ClientProfile client) async {
    lastClient = client;

    return prefs!.setInt('contractId', client.contractId);
  }
}
