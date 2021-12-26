// ignore_for_file: always_use_package_imports

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';


mixin SyncData {
  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> hiddenSyncHive({
    String? apiKey,
    String? urlAddress,
    Map<String, String>? headers,
    Box? hive,
  }) async {
    apiKey ??= AppData().profiles[0].key.apiKey;
    urlAddress ??= 'http://${AppData().profile.key.host}:48080/stat';
    hive ??= AppData().hiveData;
    headers ??= _headers;
    final body = '''{"api_key": $apiKey}''';
    try {
      final url = Uri.parse(urlAddress);
      final response = await http.post(url, headers: headers, body: body);
      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          await hive.put(apiKey + urlAddress, response.body);
          updateValueFromHive(apiKey + urlAddress);
        }
      }
    } on SocketException {
      showSimpleNotification(
        const Text('Ошибка: нет соединения с интернетом!'),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );
      dev.log('No internet connection $urlAddress ');
    } on HttpException {
      showSimpleNotification(
        const Text('Ошибка доступа к серверу!'),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );
      dev.log('Server error $urlAddress ');
    } finally {
      dev.log('sync ended $urlAddress ');
    }
  }

  void updateValueFromHive(String hiveKey);

  List<Map<String, dynamic>> hiddenUpdateValueFromHive({
    required String hiveKey,
    Box? hive,
  }) {
    hive ??= AppData().hiveData;
    try {
      final lst = List<Map<String, dynamic>>.from(
        (json.decode(hive.get(hiveKey, defaultValue: '[]') as String)
                as Iterable<dynamic>)
            .whereType<Map<String, dynamic>>(),
      );

      return lst;
    } on FormatException {
      dev.log(' Wrong json format - FormatException');
      dev.log(hive.get(hiveKey, defaultValue: '[]') as String);
      showSimpleNotification(
        const Text('Ошибка: получен неправильный ответ от сервера!'),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );

      return <Map<String, dynamic>>[];
    }
  }
}
