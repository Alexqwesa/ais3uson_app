// ignore_for_file: always_use_package_imports, prefer_final_fields

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
  /// Store Singleton
  static late final AppData _instance = AppData._internal();

  /// Global Storage [hiveData]
  late Box hiveData;

  static AppData get instance => _instance; // ??= AppData._internal();

  List<UserProfile> get profiles => _profiles;

  List<ServiceEntry> get services => _services;

  String get apiKey => profile.key.apiKey;

  /// userKeys - is user authentication data,
  Iterable<UserKey> get userKeys => _profiles.map((e) => e.key);

  /// Get first profile with working server
  UserProfile get profile {
    // TODO:
    // if (_profiles.first.connection_ok){
    return _profiles.first;
  }

  /// Services list
  List<ServiceEntry> _services = [];

  /// Profiles list
  List<UserProfile> _profiles = [];

  /// Constructor
  ///
  /// just constructor and singleton
  factory AppData() => _instance; // ??= AppData._internal();
  AppData._internal();

  @override
  void dispose() {
    // TODO:
    // hiveData.compact();
    // hiveData.close();
    // Don't dispose of singleton
    // super.dispose();
  }

  /// Update data after sync
  ///
  /// read hive data and notify
  @override
  void updateValueFromHive(String hiveKey) {
    final lstOfMaps = hiddenUpdateValueFromHive(
      hiveKey: hiveKey,
      hive: hiveData,
    );
    _services = [];
    for (final entry in lstOfMaps) {
      _services.add(ServiceEntry.fromJson(entry));
    }
    notifyListeners();
  }

  /// Post init
  ///
  /// read setting from hive, and sync
  void postInit() {
    addProfile(UserKey.fromJson(jsonDecode(qrData)));
    for (final String prof
        in hiveData.get('profileList', defaultValue: <String>[])) {
      addProfile(UserKey.fromJson(jsonDecode(prof)));
    }
    for (final String serv
        in hiveData.get('services', defaultValue: <String>[])) {
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

  void addProfile(UserKey key) {
    _profiles.add(UserProfile(key));
    notifyListeners();
  }

  /// Sync hive data
  ///
  /// sync [_services]
  Future<void> syncHive() async {
    return hiddenSyncHive(
      apiKey: apiKey,
      urlAddress: 'http://${profile.key.host}:48080/services',
    );
  }
}
