import 'dart:async';

import 'package:ais3uson_app/src/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_data.dart';
import 'client_profile.dart';
import 'from_json/fio_entry.dart';
import 'from_json/user_key.dart';

class UserProfile with SyncData {
  UserKey key;
  late String name;
  late Box hive;

  List<FioEntry> _fioList = [];
  List<FioPlanned> _fioPlanned = [];
  List<ClientProfile> _clients = [];

  List<FioEntry> get fioList => _fioList;

  List<FioPlanned> get fioPlanned => _fioPlanned;

  List<ClientProfile> get clients => _clients;

  UserProfile(this.key) {
    hive = AppData.instance.hiveData;
    name = key.name;
    // hive.delete(key.apiKey + "fioList");
    syncHive();
    syncHivePlanned();
  }

  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHive() async {
    hiddenSyncHive(
        apiKey: key.apiKey, urlAddress: "http://${key.host}:48080/fio");
  }

  Future<void> syncHivePlanned() async {
    hiddenSyncHive(
        apiKey: key.apiKey, urlAddress: "http://${key.host}:48080/Planned");
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  void updateValueFromHive(String hiveKey) {
    if (hiveKey.endsWith("http://${key.host}:48080/fio")) {
      // Sync fio list
      //
      //
      List lst = hiddenUpdateValueFromHive(
          hiveKey: hiveKey, hive: hive, fromJsonClass: FioEntry);
      if (lst.isNotEmpty) {
        _fioList = [];
        for (Map<String, dynamic> entry in lst) {
          _fioList.add(FioEntry.fromJson(entry));
        }
        _clients = _fioList.map((el) {
          return ClientProfile(el.contractId, el.ufio + " " + el.contract);
        }).toList();
        fillClientServices();
        AppData.instance.notify();
        // AppData.instance.notifyListeners();
      } else if (hiveKey.endsWith("http://${key.host}:48080/Planned")) {
        // Sync Planned services
        //
        //
        List lst = hiddenUpdateValueFromHive(
            hiveKey: "urlAddress", hive: hive, fromJsonClass: FioPlanned);
        if (lst.isNotEmpty) {
          _fioPlanned = [];
          for (Map<String, dynamic> entry in lst) {
            _fioPlanned.add(FioPlanned.fromJson(entry));
          }
          fillClientServices();
          AppData.instance.notify();
          // AppData.instance.notifyListeners();
        }
      }
    }
  }

  void fillClientServices() {
    if (_fioList.isNotEmpty || _fioPlanned.isNotEmpty) {
      for (ClientProfile clProf in _clients) {
        clProf.services.addAll(_fioPlanned.where((serv) {
          return serv.contractId == clProf.contractId;
        }));
      }
    }
  }
}
