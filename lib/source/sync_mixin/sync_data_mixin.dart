// ignore_for_file: always_use_package_imports

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';

/// Abstract mixin [SyncDataMixin]
///
/// Add synchronizing template for classes.
/// It helps:
/// - get data from network,
/// - write json string to hive,
/// - handle errors,
/// - save/restore from hive.
///
/// Classes with this mixin:
/// - can use several functions that call [hiddenSyncHive] with various parameters,
/// - should implement [updateValueFromHive] - it will be called by [hiddenSyncHive],
/// - overridden function [updateValueFromHive] usually call [hiddenUpdateValueFromHive] to get [Map] from hive.
mixin SyncDataMixin {
  //
  // > Standard headers
  //
  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get data from network (with error checks) and save it to hive.
  ///
  /// Call [updateValueFromHive] to load data into application.
  Future<void> hiddenSyncHive({
    required String urlAddress,
    String? apiKey,
    Map<String, String>? headers,
    Box? hive,
  }) async {
    apiKey ??= AppData().profiles[0].key.apiKey;
    hive ??= AppData().hiveData;
    headers ??= _headers;
    //
    // > main - call server
    //
    final body = '''{"api_key": "$apiKey"}''';
    try {
      final url = Uri.parse(urlAddress);
      final response = await http.post(url, headers: headers, body: body);
      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty && response.body != '[]') {
          await hive.put(apiKey + urlAddress, response.body);
          updateValueFromHive(apiKey + urlAddress);
        }
      }
      //
      // > just error handling
      //
    } on ClientException {
      showErrorNotification('Ошибка сервера!');
      dev.log('Server error $urlAddress ');
    } on SocketException {
      showErrorNotification('Ошибка: нет соединения с интернетом!');
      dev.log('No internet connection $urlAddress ');
    } on HttpException {
      showErrorNotification('Ошибка доступа к серверу!');
      dev.log('Server access error $urlAddress ');
    } finally {
      dev.log('sync ended $urlAddress ');
    }
  }

  /// Should be defined in descendant class.
  ///
  /// Usually just call [hiddenUpdateValueFromHive] to get data from hive,
  /// and convert it to user class.
  void updateValueFromHive(String hiveKey);

  /// This function should be called from [updateValueFromHive].
  ///
  /// Read hive string and return [Map].
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
        const Text('Ошибка: был получен неправильный ответ от сервера!'),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );

      return <Map<String, dynamic>>[];
    }
  }
}
