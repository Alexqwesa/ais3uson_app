import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../global.dart';
import 'app_data.dart';

mixin SyncData {
  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<void> hiddenSyncHive({apiKey, urlAddress, headers, hive}) async {
    apiKey ??= AppData().profiles[0].key.apiKey;
    urlAddress ??=  'http://${AppData().profile.key.host}:48080/stat';
    hive ??= AppData().hiveData;
    headers ??= _headers;
    String body = '''{"api_key": $apiKey}''';
    try {
      var url = Uri.parse(urlAddress);
      Response response = await http.post(url, headers: headers, body: body);
      dev.log("$urlAddress response.statusCode = ${response.statusCode}");
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          hive.put(apiKey + urlAddress, response.body);
          updateValueFromHive(apiKey + urlAddress);
        }
      }
    } catch (e) {
      dev.log(e.toString());
    } finally {
      dev.log("sync ended $urlAddress ");
    }
  }

  void updateValueFromHive(String hiveKey) {}

  List<dynamic> hiddenUpdateValueFromHive({hive, hiveKey, fromJsonClass}) {
    hive ??= AppData().hiveData;
    try {
      List<dynamic> lst = json.decode(hive.get(hiveKey, defaultValue: "[]"));
      if (lst.isEmpty) {
        return [];
      } else {
        return lst;
      }
    } catch (e) {
      return [];
    }
  }
}
