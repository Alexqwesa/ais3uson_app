// ignore_for_file: always_use_package_imports

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
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

  String get apiKey {
    return 'apiKey not Implemented';
  }

  /// Get data from network (with error checks) and save it to hive.
  ///
  /// Call [updateValueFromHive] to load data into application.
  Future<void> hiddenSyncHive({
    required String urlAddress,
    String? apiKey,
    Map<String, String>? headers,
    Box? hive,
    http.Client? client,
  }) async {
    apiKey ??= AppData().profiles[0].key.apiKey;
    hive ??= AppData().hiveData;
    headers ??= {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'api_key': apiKey,
    };
    client ??= AppData().httpClient;
    //
    // > main - call server
    //
    try {
      final url = Uri.parse(urlAddress);
      final response = await client.get(url); //, headers: headers);
      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty && response.body != '[]') {
          // for getting new test data
          // print("=== " + apiKey + urlAddress);
          // print("=== " + response.body);
          await hive.put(apiKey + urlAddress, response.body);
          updateValueFromHive(apiKey + urlAddress);
        }
      }
      //
      // > just error handling
      //
    } on http.ClientException {
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
