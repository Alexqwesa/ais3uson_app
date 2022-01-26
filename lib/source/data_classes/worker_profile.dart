// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/sync_mixin/sync_data_mixin.dart';
import 'package:flutter/material.dart';

/// A profile of worker.
///
/// It created from authentication QR code (or text).
///
/// It main purpose is to store [Journal] and get bunch of sync data via:
/// - [syncHiveServices],
/// - [syncHiveFio],
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

  DateTime _servicesSyncDate = DateTime.utc(1900);
  DateTime _clientPlanSyncDate = DateTime.utc(1900);

  String get apiKey => key.apiKey;

  List<ClientPlan> get clientPlan => _clientPlan;

  List<ClientProfile> get clients => _clients;

  List<ServiceEntry> get services => _services;

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

  /// Constructor [WorkerProfile].
  ///
  /// init/postinit and call async functions to sync data.
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
    if (hiveKey.endsWith('http://${key.host}:${key.port}/clients')) {
      //
      // > Get ClientProfile from hive
      //
      _clients =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<ClientEntry>((json) {
        return ClientEntry.fromJson(json);
      }).map((el) {
        return ClientProfile(
          workerProfile: this,
          contractId: el.contractId,
          name: '${el.client} ${el.contract}',
        );
      }).toList(growable: false);
    } else if (hiveKey.endsWith('http://${key.host}:${key.port}/planned')) {
      //
      // > Sync Planned services from hive
      //
      _clientPlan =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<ClientPlan>((json) {
        return ClientPlan.fromJson(json);
      }).toList(growable: false);
      _clientPlanSyncDate = DateTime.now();
      unawaited(journal.updateWithNewPlan());
    } else if (hiveKey.endsWith('http://${key.host}:${key.port}/services')) {
      //
      // > Sync services from hive
      //
      _services =
          hiddenUpdateValueFromHive(hiveKey: hiveKey).map<ServiceEntry>((json) {
        return ServiceEntry.fromJson(json);
      }).toList(growable: false);
      _servicesSyncDate = DateTime.now();
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
    } else if (_servicesSyncDate.isBefore(_clientPlanSyncDate)) {
      await syncHiveServices();
    } else {
      // TODO: actual checks here
    }
  }
}
