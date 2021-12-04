import 'dart:async';
import 'dart:convert';
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
class AppData with ChangeNotifier {
  /// should be initiated in init() function
  late Box hiveData;
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
  List<UserProfile> _profiles = [];
  List<ServiceEntry> serviceList = [];

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
  }

  /// userKeys section
  ///
  /// userKeys - is user authentication data,
  /// this section update [UserKeys]s and notifies about changes
  Iterable<UserKey> get userKeys => _profiles.map((e) => e.key);

  UserProfile get profile => _profiles.first;

  List<UserProfile> get profiles => _profiles;

  // final StreamController<bool> _ukUpdate = StreamController<bool>.broadcast();

  // Stream<bool> get updStreamUK => _ukUpdate.stream;

  void addProfile(UserKey key) {
    _profiles.add(UserProfile(key));
    // _ukUpdate.sink.add(true);
    notifyListeners();
  }
}
