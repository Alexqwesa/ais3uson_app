import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../src/sync/fio_entry.dart';
import 'sync/user_key.dart';

const String SERVER = "http://80.87.196.11";
String qrData =
    '''{"app": "AIS3USON web", "name": "test", "api_key": "123", "otd_id": 1, "otd": "otd test", "db": "kcson", "host": "192.168.0.102", "port": "48080"}''';

/// Global AppData
///
/// global singleton class
/// for storing global data
/// and notifies listeners
class AppData {
  /// should be initiated in init() function
  late Box hiveData;
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  List<UserProfile> _profiles = [];

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
  final StreamController<bool> _ukUpdate = StreamController<bool>.broadcast();

  Stream<bool> get updStreamUK => _ukUpdate.stream;

  void addProfile(UserKey key) {
    _profiles.add(UserProfile(key));
    _ukUpdate.sink.add(true);
  }
}

class UserProfile {
  UserKey key;
  late String name;
  late Box hive;

  List<FioEntry> fioList = [];

  UserProfile(this.key) {
    hive = AppData.instance.hiveData;
    name = key.name;
    // hive.delete(key.apiKey + "fioList");
    readHive();
    syncfio();
  }

  void readHive() {
    // return;
    try {
      List<dynamic> lst =
          json.decode(hive.get(key.apiKey + "fioList", defaultValue: "[]"));
      for (Map<String, dynamic> fio in lst) {
        if (fio != null) {
          fioList.add(FioEntry.fromJson(fio));
        }
      }
    } finally {}
  }

  // void postInit() {
  // }

  Future<void> syncfio() async {
    var url = Uri.parse(SERVER + ':48080/fio');
    Response response = await http.post(url,
        headers: AppData.instance.headers, body: key.httpBody);
    if (response.statusCode == 200) {
      print(response.body);
      // dynamic lst = jsonDecode(response.body);
      try {
        hive.put(key.apiKey + "fioList", response.body);
        readHive();
        _updFio.sink.add(true);
      } finally {}
    }
  }

  final StreamController<bool> _updFio = StreamController<bool>.broadcast();

  Stream<bool> get updFio => _updFio.stream;

  void dispose() {
    _updFio.close();
  }
}
