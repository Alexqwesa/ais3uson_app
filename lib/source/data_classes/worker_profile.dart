// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/sync_mixin/sync_data_mixin.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A profile of worker.
///
/// It created from authentication QR code (or text).
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
  late final WorkerKey key;
  late final Journal journal;
  late final String name;

  @override
  String get apiKey => key.apiKey;

  List<ClientPlan> get clientPlan => _clientPlan;

  List<ClientProfile> get clients => _clients;

  List<ServiceEntry> get services => _services;

  /// Store date and time of last sync for [_services].
  DateTime _servicesSyncDate = startDate;

  /// Store date and time of last sync for [_clientPlan].
  DateTime _clientPlanSyncDate = startDate;

  /// Store date and time of last sync for [_clients].
  DateTime _clientSyncDate = startDate;

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
  WorkerProfile(this.key, {DateTime? archiveDate}) {
    name = key.name;
    journal =
        archiveDate != null ? JournalArchive(this, archiveDate) : Journal(this);
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
  Future<void> updateValueFromHive(String hiveKey, Box hive) async {
    if (hiveKey.endsWith('http://${key.host}:${key.port}/clients')) {
      //
      // > Get ClientProfile from hive
      //
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
    } else if (hiveKey.endsWith('http://${key.host}:${key.port}/planned')) {
      //
      // > Sync Planned services from hive
      //
      _clientPlan = hiddenUpdateValueFromHive(hiveKey: hiveKey, hive: hive)
          .map<ClientPlan>((json) {
        return ClientPlan.fromJson(json);
      }).toList(growable: false);
      await setClientPlanSyncDate();
      // maybe await it later to call notifyListeners before it?
      await journal.updateBasedOnNewPlanDate();
    } else if (hiveKey.endsWith('http://${key.host}:${key.port}/services')) {
      //
      // > Sync services from hive
      //
      _services = hiddenUpdateValueFromHive(hiveKey: hiveKey, hive: hive)
          .map<ServiceEntry>((json) {
        return ServiceEntry.fromJson(json);
      }).toList(growable: false);
      await setServicesSyncDate();
    } else {
      return;
    }
    //
    // > And finally notify
    //
    notifyListeners();
  }

  @override
  void dispose() {
    journal.dispose();

    return super.dispose();
  }

  Future<DateTime> servicesSyncDate() async {
    if (_servicesSyncDate == startDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_servicesSyncDate',
        defaultValue:
            startDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
      ) as int;
      _servicesSyncDate = DateTime.fromMillisecondsSinceEpoch(since);
    }

    return _servicesSyncDate;
  }

  Future<DateTime> clientPlanSyncDate() async {
    if (_clientPlanSyncDate == startDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_clientPlanSyncDate',
        defaultValue:
            startDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
      ) as int;
      _clientPlanSyncDate = DateTime.fromMillisecondsSinceEpoch(since);
    }

    return _clientPlanSyncDate;
  }

  Future<DateTime> clientSyncDate() async {
    if (_clientSyncDate == startDate) {
      int since;
      final hive = await Hive.openBox<dynamic>(hiveName);
      since = await hive.get(
        '${apiKey}_clientSyncDate',
        defaultValue:
            startDate.add(const Duration(days: 1)).millisecondsSinceEpoch,
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
  /// - get last sync dates for [clients], [clientPlan] and [services] from hive,
  /// - check dates of last sync and call updates.
  Future<void> postInit() async {
    await journal.postInit();
    await Hive.openBox<dynamic>(hiveName);
    final plannedUpdate = DateTime.now().add(const Duration(hours: -2));
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
  Future<void> syncHiveClients() async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:${key.port}/clients',
    );
  }

  Future<void> syncHivePlanned() async {
    if (_services.isEmpty) {
      await syncHiveServices();
    }
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:${key.port}/planned',
    );
  }

  /// Synchronize services for [WorkerProfile._services].
  ///
  /// Services usually updated once per year, and before calling this function we
  /// should check: is it really necessary, i.e. is [_services] empty.
  ///
  /// This function also called from [checkAllServicesExist] if there is [_clientPlan]
  /// with wrong [ClientPlan.servId].
  Future<void> syncHiveServices() async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:${key.port}/services',
    );
  }

  /// This function should only be called if there is inconsistency: [ClientPlan] had nonexist service Id.
  ///
  /// This can happen:
  /// - once per year, then list of [ServiceEntry] is updated - just sync via [syncHiveServices].
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
