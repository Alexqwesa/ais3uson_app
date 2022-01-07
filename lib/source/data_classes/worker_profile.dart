// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/source/data_classes/sync_mixin.dart';
import 'package:flutter/material.dart';

import 'client_profile.dart';
import 'from_json/fio_entry.dart';
import 'from_json/service_entry.dart';
import 'from_json/worker_key.dart';
import '../journal/journal.dart';

/// [WorkerProfile]
///
/// profile of worker created from authentication QR code (or line)
/// store and sync data of
// ignore: prefer_mixin
class WorkerProfile with SyncData, ChangeNotifier {
  late final WorkerKey key;
  late final Journal journal;
  late final String name;

  List<FioPlanned> get fioPlanned => _fioPlanned;

  List<ClientProfile> get clients => _clients;

  List<ServiceEntry> get services => _services;

  /// Services list
  ///
  /// since worker could potentially work
  /// on two different organizations (half rate in each),
  /// with different services - we store services in worker profile
  /// (not in app profile)
  List<ServiceEntry> _services = [];

  /// Planned amount of services for client
  ///
  /// since we get data in bunch - store it here
  List<FioPlanned> _fioPlanned = [];

  /// list of clients List<ClientProfile>
  List<ClientProfile> _clients = [];

  /// Constructor [WorkerProfile]
  ///
  /// init and call async function to sync data
  WorkerProfile(this.key) {
    name = key.name;
    journal = Journal(this);
    journal.postInit();
    if (_services.isEmpty) {
      syncHiveServices();
    }
    syncHiveFio();
    syncHivePlanned();
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  Future<void> updateValueFromHive(String hiveKey) async {
    if (hiveKey.endsWith('http://${key.host}:48080/fio')) {
      //
      // > Get ClientProfile from hive
      //
      _clients =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<FioEntry>((json) {
        return FioEntry.fromJson(json);
      }).map((el) {
        return ClientProfile(
          workerProfile: this,
          contractId: el.contractId,
          name: '${el.ufio} ${el.contract}',
        );
      }).toList(growable: false);
    } else if (hiveKey.endsWith('http://${key.host}:48080/planned')) {
      //
      // > Sync Planned services from hive
      //
      _fioPlanned =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<FioPlanned>((json) {
        return FioPlanned.fromJson(json);
      }).toList(growable: false);
    } else if (hiveKey.endsWith('http://${key.host}:48080/services')) {
      //
      // > Sync services from hive
      //
      _services =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<ServiceEntry>((json) {
        return ServiceEntry.fromJson(json);
      }).toList(growable: false);
    } else {
      return;
    }
    //
    // > And finally notify
    //
    notifyListeners();
  }

  /// Sync hive data
  ///
  /// sync [WorkerProfile]  data
  Future<void> syncHiveFio() async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:48080/fio',
    );
  }

  Future<void> syncHivePlanned() async {
    if (_services.isEmpty) {
      await syncHiveServices();
    }
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:48080/planned',
    );
  }

  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHiveServices() async {
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:48080/services',
    );
  }
}
