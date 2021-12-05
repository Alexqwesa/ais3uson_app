import 'dart:async';
import 'dart:convert';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../global.dart';
import 'app_data.dart';
import 'from_json/fio_entry.dart';
import 'from_json/user_key.dart';

class UserProfile with SyncData {
  UserKey key;
  late String name;
  late Box hive;

  List<FioEntry> _fioList = [];

  List<FioEntry> get fioList => _fioList;

  UserProfile(this.key) {
    hive = AppData.instance.hiveData;
    name = key.name;
    // hive.delete(key.apiKey + "fioList");
    syncHive();
  }

  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHive() async {
    return hiddenSyncHive(apiKey: key.apiKey, urlAddress: "$SERVER:48080/fio");
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  void updateValueFromHive() {
    List lst = hiddenUpdateValueFromHive(
        hiveKey: key.apiKey + "fioList", hive: hive, fromJsonClass: FioEntry);
    if (lst.isNotEmpty) {
      _fioList = [];
      for (Map<String, dynamic> entry in lst) {
        _fioList.add(FioEntry.fromJson(entry));
      }
      AppData.instance.notify();
    }
  }
}
