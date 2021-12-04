import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import '../global.dart';
import 'app_data.dart';
import 'from_json/fio_entry.dart';
import 'from_json/user_key.dart';

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
      if (lst.length > 0) {
        fioList.clear();
      }
      for (Map<String, dynamic> fio in lst) {
        // if (fio != null) {
        fioList.add(FioEntry.fromJson(fio));
        // }
      }
    } finally {}
  }

  Future<void> syncfio() async {
    try {
      var url = Uri.parse(SERVER + ':48080/fio');
      Response response = await http.post(url,
          headers: AppData.instance.headers, body: key.httpBody);
      dev.log("fioList response.statusCode = ${response.statusCode}");
      if (response.statusCode == 200) {
        hive.put(key.apiKey + "fioList", response.body);
        readHive();
        _updFio.sink.add(true);
      }
    } catch (e) {
      dev.log(e.toString());
    } finally {}
  }

  final StreamController<bool> _updFio = StreamController<bool>.broadcast();

  Stream<bool> get updFio => _updFio.stream;

  void dispose() {
    _updFio.close();
  }
}
