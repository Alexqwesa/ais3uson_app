import 'dart:convert';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'helpers/mock_server.dart' show getMockHttpClient;

/// [WorkerKey] modified for tests (ssl='no')
WorkerKey wKeysData2() {
  final json = jsonDecode(qrData2WithAutossl) as Map<String, dynamic>;
  json['ssl'] = 'no';

  return WorkerKey.fromJson(json);
}

void main() {
  //
  // > Setup
  //
  tearDownAll(() async {
    Singleton.resetAllForTest();
    await tearDownTestHive();
  });
  setUp(() async {
    // Cleanup
    Singleton.resetAllForTest();
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
    // httpClient setup
    AppData().httpClient = getMockHttpClient();
  });
  tearDown(() async {
    await AppData().asyncDispose();
    AppData().dispose();
    Singleton.resetAllForTest();
    await tearDownTestHive();
  });
  //
  // > Tests start
  //
  group('AppData Class', () {
    test('it create WorkerProfiles from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'WorkerKeys':
            '[{"app":"AIS3USON web","name":"Работник Тестового Отделения №2","api_key":"3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c","worker_dep_id":1,"dep":"Тестовое отделение https://alexqwesa.fvds.ru:48082","db":"kcson","host":"alexqwesa.fvds.ru","port":"48082","comment":"защищенный SSL","ssl":"auto","certBase64":""}]',
      });
      await AppData.instance.postInit();
      expect(AppData.instance.profiles.length, 1);
      expect(AppData.instance.profiles.first.apiKey,
          '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c');
    });
  });
}
