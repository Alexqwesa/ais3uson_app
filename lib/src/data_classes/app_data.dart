import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:ais3uson_app/src/data_classes/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import '../global.dart';
import 'from_json/service_entry.dart';
import 'from_json/user_key.dart';

import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

/// Global AppData
///
/// global singleton class
/// for storing global data
/// and notifies listeners
class AppData with ChangeNotifier, SyncData {
  /// should be initiated in init() function
  late Box hiveData;
  List<UserProfile> _profiles = [];

  // List<ServiceEntry> serviceList = [];
  List<ServiceEntry> _services = [];

  /// Init section
  ///
  /// just constructor and singleton
  static AppData? _instance;

  factory AppData() => _instance ??= AppData._internal();

  static AppData get instance => _instance ??= AppData._internal();

  AppData._internal();

  void postInit() {
    addProfile(UserKey.fromJson(jsonDecode(qrData)));
    for (String prof in hiveData.get("profileList", defaultValue: [])) {
      addProfile(UserKey.fromJson(jsonDecode(prof)));
    }
    for (String serv in hiveData.get("services", defaultValue: [])) {
      _services.add(ServiceEntry.fromJson(jsonDecode(serv)));
    }
    if (_services.isEmpty) {
      syncHive();
    }
  }

  /// userKeys section
  ///
  /// userKeys - is user authentication data,
  /// this section update [UserKeys]s and notifies about changes
  Iterable<UserKey> get userKeys => _profiles.map((e) => e.key);

  String get apiKey => _profiles.first.key.apiKey;

  UserProfile get profile => _profiles.first;

  List<UserProfile> get profiles => _profiles;

  void addProfile(UserKey key) {
    _profiles.add(UserProfile(key));
    notifyListeners();
  }

  List<ServiceEntry> get services => _services;
  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHive() async {
    return hiddenSyncHive(apiKey: apiKey, urlAddress: "$SERVER:48080/services");
  }

  /// Update data after sync
  ///
  /// read hive sync
  @override
  void updateValueFromHive() {
    List lst = hiddenUpdateValueFromHive(
        hiveKey: "services", hive: hiveData, fromJsonClass: ServiceEntry);
    if (lst.isNotEmpty) {
      List<ServiceEntry> _services = [];
      for (Map<String, dynamic> entry in lst) {
        _services.add(ServiceEntry.fromJson(entry));
      }
      notifyListeners();
    }
  }
}
