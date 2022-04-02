// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/sync_mixin/sync_data_mixin.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A profile of worker.
///
/// It created from authentication QR code (or text) via [WorkerKey].
///
/// It main purpose is to store [Journal] and get bunch of sync data via:
/// - [syncHiveServices],
/// - [syncHiveClients],
/// - [syncHivePlanned].
///
/// Also it is notifying widgets.
///
/// {@category Data_Classes}
// ignore: prefer_mixin
class WorkerProfile with SyncDataMixin, ChangeNotifier {
  final WorkerKey key;
  late final Journal journal;
  late final JournalArchive fullArchive;
  late final String name;

  final ProviderContainer ref;

  @override
  String get apiKey => key.apiKey;

  List<ClientPlan> get clientPlan => _clientPlan;

  List<ClientProfile> get clients => _clients;

  List<ServiceEntry> get services => _services;

  /// Store date and time of last sync for [_services].
  DateTime _servicesSyncDate = nullDate;

  /// Store date and time of last sync for [_clientPlan].
  DateTime _clientPlanSyncDate = nullDate;

  /// Store date and time of last sync for [_clients].
  DateTime _clientSyncDate = nullDate;

  /// Service list should only update on empty, or unknown planned service.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  /// TODO: update by server policy.
  List<ServiceEntry> _services = [];

  /// Planned amount of services for client.
  ///
  /// Since we get data in bunch - store it in [WorkerProfile].
  List<ClientPlan> _clientPlan = [];

  /// list of clients List<ClientProfile>
  List<ClientProfile> _clients = [];

  /// Constructor [WorkerProfile] with [Journal] by default
  /// or with [JournalArchive].
  ///
  /// TODO: finish detect SSL code
  WorkerProfile(this.key, this.ref, {DateTime? archiveDate}) {
    name = key.name;
    journal =
        archiveDate != null ? JournalArchive(this, archiveDate) : Journal(this);
    fullArchive = JournalArchive(this, null);
    httpClient = ref.read(httpClientProvider);
    try {
      if (key.certBase64.isNotEmpty) {
        final context = SecurityContext()
          ..setTrustedCertificatesBytes(key.certificate);
        sslClient = HttpClient(context: context)
          ..badCertificateCallback = (cert, host, port) {
            // if (host == '80.87.196.11') {
            //   // for debug
            //   return true;
            // }
            dev.log('!!!!Bad certificate');
            showErrorNotification('Ошибка! неправильный сертификат сервера!');

            return false;
          };
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      dev.log('!!!!Bad certificate');
      showErrorNotification(
        'Ошибка! Не удалось добавить сертификат отделения!',
      );
    }
  }

  @override
  void dispose() {
    journal.dispose();

    return super.dispose();
  }

  /// Update data after sync read from hive and notify.
  ///
  /// Recreate :
  /// - [_clients] - list of [ClientProfile],
  /// - [_clientPlan] - list of [ClientPlan],
  /// - [_services] - list of [ServiceEntry].
  ///
  /// read hive data and notify
  @override
  Future<void> updateValueFromHive(
    String hiveKey,
    Box hive, {
    bool onlyIfEmpty = false,
  }) async {
    if (hiveKey.endsWith('/clients')) {
      //
      // > Get ClientProfile from hive
      //
      if (!onlyIfEmpty || _clients.isEmpty) {
        _clients = hiddenUpdateValueFromHive(hiveKey: hiveKey, hive: hive)
            .map<ClientEntry>((json) {
          return ClientEntry.fromJson(json);
        }).map((el) {
          return ClientProfile(
            workerProfile: this,
            entry: el,
          );
        }).toList(growable: false);

        await setClientSyncDate();
      }
    } else if (hiveKey.endsWith('/planned')) {
      //
      // > Sync Planned services from hive
      //
      if (!onlyIfEmpty || _clientPlan.isEmpty) {
        _clientPlan = hiddenUpdateValueFromHive(hiveKey: hiveKey, hive: hive)
            .map<ClientPlan>((json) {
          return ClientPlan.fromJson(json);
        }).toList(growable: false);
        await setClientPlanSyncDate();
        // maybe await it later to call notifyListeners before it?
        await journal.updateBasedOnNewPlanDate();
      }
    } else if (hiveKey.endsWith('/services')) {
      //
      // > Sync services from hive
      //
      if (!onlyIfEmpty || _clientPlan.isEmpty) {
        _services = hiddenUpdateValueFromHive(hiveKey: hiveKey, hive: hive)
            .map<ServiceEntry>((json) {
          return ServiceEntry.fromJson(json);
        }).toList(growable: false);
        await setServicesSyncDate();
      }
    } else {
      return;
    }
    //
    // > And finally notify
    //
    notifyListeners();
  }

  WorkerProfile copyWith({DateTime? archiveDate}) {
    return WorkerProfile(key, ref, archiveDate: archiveDate);
  }

  Future<DateTime> servicesSyncDate() async {
    if (_servicesSyncDate == nullDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_servicesSyncDate',
        defaultValue:
            nullDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
      ) as int;
      _servicesSyncDate = DateTime.fromMillisecondsSinceEpoch(since);
    }

    return _servicesSyncDate;
  }

  Future<DateTime> clientPlanSyncDate() async {
    if (_clientPlanSyncDate == nullDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_clientPlanSyncDate',
        defaultValue:
            nullDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
      ) as int;
      _clientPlanSyncDate = DateTime.fromMillisecondsSinceEpoch(since);
    }

    return _clientPlanSyncDate;
  }

  Future<DateTime> clientSyncDate() async {
    if (_clientSyncDate == nullDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_clientSyncDate',
        defaultValue:
            nullDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
      ) as int;
      _clientSyncDate = DateTime.fromMillisecondsSinceEpoch(since);
    }

    return _clientSyncDate;
  }

  Future<void> setClientSyncDate({DateTime? newDate}) async {
    _clientSyncDate = newDate ?? DateTime.now();
    final hive = await Hive.openBox<dynamic>(hiveName);
    await hive.put(
      '${apiKey}_clientSyncDate',
      _clientSyncDate.millisecondsSinceEpoch,
    );
  }

  Future<void> setClientPlanSyncDate({DateTime? newDate}) async {
    _clientPlanSyncDate = newDate ?? DateTime.now();
    final hive = await Hive.openBox<dynamic>(hiveName);
    await hive.put(
      '${apiKey}_clientPlanSyncDate',
      _clientPlanSyncDate.millisecondsSinceEpoch,
    );
  }

  Future<void> setServicesSyncDate({DateTime? newDate}) async {
    _servicesSyncDate = newDate ?? DateTime.now();
    final hive = await Hive.openBox<dynamic>(hiveName);
    await hive.put(
      '${apiKey}_servicesSyncDate',
      _servicesSyncDate.millisecondsSinceEpoch,
    );
  }

  /// Async init actions such as:
  ///
  /// - postInit [journal] (instance of [Journal] class),
  /// - read [clients], [clientPlan] and [services] from hive if empty,
  /// - check last sync dates and sync [clients], [clientPlan] and [services],
  /// - and call notifyListeners.
  Future<void> postInit() async {
    await journal.postInit();
    await Hive.openBox<dynamic>(hiveName);
    final plannedUpdate = DateTime.now().add(const Duration(hours: -2));
    //
    // > read hive values
    //
    if (_services.isEmpty) {
      await syncHiveServices(localOnly: true);
    }
    if (clients.isEmpty) {
      await syncHiveClients(localOnly: true);
    }
    if (clientPlan.isEmpty) {
      await syncHivePlanned(localOnly: true);
    }
    if (clientPlan.isNotEmpty) notifyListeners();
    //
    // > sync if time right
    //
    if ((await servicesSyncDate()).isBefore(plannedUpdate)) {
      if (_services.isEmpty) {
        await syncHiveServices();
      }
    }
    if ((await clientSyncDate()).isBefore(plannedUpdate)) {
      await syncHiveClients();
    }
    if ((await clientPlanSyncDate()).isBefore(plannedUpdate)) {
      await syncHivePlanned();
    }
    // await ensureClientInitialized(); // delete it?
    notifyListeners();
  }

  /// Make sure all [ClientService]s of [ClientProfile] is initialized.
  Future<void> ensureClientInitialized() async {
    await Future.wait(
      clients.map(
        (element) {
          return element.updateServices();
        },
      ),
    );
  }

  /// Sync hive data
  ///
  /// sync [WorkerProfile]  data
  Future<void> syncHiveClients({bool localOnly = false}) async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: '${key.activeServer}/clients',
      localOnly: localOnly,
    );
  }

  Future<void> syncHivePlanned({bool localOnly = false}) async {
    if (_services.isEmpty) {
      await syncHiveServices();
    }
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: '${key.activeServer}/planned',
      localOnly: localOnly,
    );
  }

  /// Synchronize services for [WorkerProfile._services].
  ///
  /// Services usually updated once per year, and before calling this function
  /// we should check: is it really necessary, i.e. is [_services] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [_clientPlan] with wrong [ClientPlan.servId].
  Future<void> syncHiveServices({bool localOnly = false}) async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: '${key.activeServer}/services',
      localOnly: localOnly,
    );
  }

  /// This should only be called if there is inconsistency:
  ///
  /// [ClientPlan] had nonexist service Id. This can happen:
  /// - then list of [ServiceEntry] is reduced on server,
  /// - database has inconsistency. TODO: check it here - low priority.
  Future<void> checkAllServicesExist() async {
    if (_services.isEmpty) {
      await syncHiveServices();
    } else if ((await servicesSyncDate())
        .isBefore(await clientPlanSyncDate())) {
      await syncHiveServices();
    } else {
      // TODO: actual checks here
    }
  }
}
