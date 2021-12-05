import 'dart:convert';
import 'package:http/http.dart';
import '../global.dart';
import 'app_data.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

mixin SyncData {
  Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<void> hiddenSyncHive({apiKey, urlAddress, headers, hive}) async {
    apiKey ??= AppData().profiles[0].key.apiKey;
    urlAddress ??= SERVER + ':48080/stat';
    hive ??= AppData().hiveData;
    headers ??= _headers;
    String body = '''{"api_key": $apiKey}''';
    try {
      var url = Uri.parse(urlAddress);
      Response response = await http.post(url, headers: headers, body: body);
      dev.log("$urlAddress response.statusCode = ${response.statusCode}");
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          hive.put(apiKey + "fioList", response.body);
          updateValueFromHive();
        }
      }
    } catch (e) {
      dev.log(e.toString());
    } finally {}
  }

  void updateValueFromHive() {}

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
