// ignore_for_file: always_use_package_imports

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
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
  /// Standard name of HiveBox.
  ///
  /// Can be considered const, but can be changed for testing purposes.
  String hiveName = 'profiles';

  HttpClient? sslClient;

  /// Should be reimplemented in children.
  ///
  /// Used to identify unique hive keys. Like in code below:
  /// ```dart
  /// await hive.put(apiKey + urlAddress, response.body);
  /// ```
  String get apiKey {
    return 'apiKey not Implemented';
  }

  /// Get data from network (with error checks) and save it to hive.
  ///
  /// First it call [updateValueFromHive] with parameter 'onlyIfEmpty=true' to get values from hive.
  /// Then it wait network data, put response to hive
  /// and call [updateValueFromHive] to display new data.
  Future<void> hiddenSyncHive({
    required String urlAddress,
    required String apiKey,
    Map<String, String>? headers,
  }) async {
    headers ??= {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'api_key': apiKey,
    };
    //
    // > if values are empty get them from hive before waiting from network
    //
    final hive = await Hive.openBox<dynamic>(hiveName);
    updateValueFromHive(apiKey + urlAddress, hive, onlyIfEmpty: true);
    //
    // > main - call server
    //
    try {
      late http.Response response;
      if (sslClient != null) {
        final httpClient = IOClient(sslClient);
        final url = Uri.parse(urlAddress.replaceFirst('http', 'https'));
        response = await httpClient.get(url, headers: headers);
      } else {
        final client = AppData.instance.httpClient;
        final url = Uri.parse(urlAddress);
        response = await client.get(url, headers: headers);
      }

      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          // for getting new test data
          // print("=== " + apiKey + urlAddress);
          // print("=== " + response.body);
          await hive.put(apiKey + urlAddress, response.body);
          updateValueFromHive(apiKey + urlAddress, hive);
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
  void updateValueFromHive(
    String hiveKey,
    Box hive, {
    bool onlyIfEmpty = false,
  });

  /// This function should be called from [updateValueFromHive].
  ///
  /// Read hive string and return [Map].
  List<Map<String, dynamic>> hiddenUpdateValueFromHive({
    required String hiveKey,
    required Box hive,
  }) {
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
