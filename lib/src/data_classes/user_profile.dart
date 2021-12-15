// ignore_for_file: always_use_package_imports

import 'dart:async';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'client_profile.dart';
import 'from_json/fio_entry.dart';
import 'from_json/user_key.dart';

class WorkerProfile with SyncData {
  UserKey key;
  late String name;
  late Box hive;

  List<FioEntry> get fioList => _fioList;

  List<FioPlanned> get fioPlanned => _fioPlanned;

  List<ClientProfile> get clients => _clients;

  List<FioEntry> _fioList = [];
  List<FioPlanned> _fioPlanned = [];
  List<ClientProfile> _clients = [];

  WorkerProfile(this.key) {
    hive = AppData.instance.hiveData;
    name = key.name;
    // hive.delete(key.apiKey + "fioList");
    syncHiveFio();
    syncHivePlanned();
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  void updateValueFromHive(String hiveKey) {
    if (hiveKey.endsWith('http://${key.host}:48080/fio')) {
      // Sync fio list
      //
      // get data
      final lstOfMaps = hiddenUpdateValueFromHive(
        hiveKey: hiveKey,
        hive: hive,
      );
      // convert data
      _fioList = [];
      for (final entry in lstOfMaps) {
        _fioList.add(FioEntry.fromJson(entry));
      }
      _clients = _fioList.map((el) {
        return ClientProfile(el.contractId, '${el.ufio} ${el.contract}');
      }).toList();
      // post convert - notify
      fillClientServices();
      AppData.instance.notify();
      // AppData.instance.notifyListeners();
    } else if (hiveKey.endsWith('http://${key.host}:48080/planned')) {
      // Sync Planned services
      //
      //
      final lstOfMaps = hiddenUpdateValueFromHive(
        hiveKey: hiveKey,
        hive: hive,
      );
      _fioPlanned = [];
      for (final entry in lstOfMaps) {
        _fioPlanned.add(FioPlanned.fromJson(entry));
      }
      fillClientServices();
      AppData.instance.notify();
      // AppData.instance.notifyListeners();
    }
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
    await hiddenSyncHive(
      apiKey: key.apiKey,
      urlAddress: 'http://${key.host}:48080/planned',
    );
  }

  void fillClientServices() {
    if (_fioList.isNotEmpty || _fioPlanned.isNotEmpty) {
      for (final clProf in _clients) {
        clProf.services.addAll(_fioPlanned.where((serv) {
          return serv.contractId == clProf.contractId;
        }));
      }
    }
  }
}
