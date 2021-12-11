import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:ais3uson_app/src/data_classes/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../global.dart';
import 'from_json/service_entry.dart';
import 'from_json/user_key.dart';

/// Global AppData
///
/// global singleton class
/// for storing global data
/// and notifies listeners
class AppData with ChangeNotifier, SyncData {
  late Box hiveData;
  List<UserProfile> _profiles = [];

  /// Init section
  ///
  /// just constructor and singleton
  static late final AppData _instance = AppData._internal();

  factory AppData() => _instance; // ??= AppData._internal();

  static AppData get instance => _instance; // ??= AppData._internal();

  AppData._internal();

  @override
  void dispose() {
    // TODO:
    // hiveData.compact();
    // hiveData.close();
    // Don't dispose of singleton
    // super.dispose();
  }

  /// Post init
  ///
  /// read setting from hive, and sync
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

  void notify() {
    // is it needed?
    notifyListeners();
  }

  /// userKeys section
  ///
  /// userKeys - is user authentication data,
  Iterable<UserKey> get userKeys => _profiles.map((e) => e.key);

  String get apiKey => _profiles.first.key.apiKey;

  /// profiles section
  ///
  /// init, getter, add
  UserProfile get profile => _profiles.first;

  List<UserProfile> get profiles => _profiles;

  void addProfile(UserKey key) {
    _profiles.add(UserProfile(key));
    notifyListeners();
  }

  /// Services section
  ///
  ///
  List<ServiceEntry> _services = [];

  List<ServiceEntry> get services => _services;

  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHive() async {
    return hiddenSyncHive(
        apiKey: apiKey, urlAddress: "http://${profile.key.host}:48080/services");
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  void updateValueFromHive(String hiveKey) {
    List lst = hiddenUpdateValueFromHive(
        hiveKey: hiveKey, hive: hiveData, fromJsonClass: ServiceEntry);
    if (lst.isNotEmpty) {
      _services = [];
      for (Map<String, dynamic> entry in lst) {
        _services.add(ServiceEntry.fromJson(entry));
      }
      notifyListeners();
    }
  }
}
