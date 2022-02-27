import 'dart:convert';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'helpers/mock_server.dart' show ExtMock, getMockHttpClient;
import 'helpers/mock_server.mocks.dart' as mock;

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
    // init AppData
    await AppData().postInit();
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
  group('Data Classes', () {
    test('it create WorkerProfile from short key', () async {
      expect(
        WorkerProfile(
          WorkerKey.fromJson(
            jsonDecode(qrDataShortKey) as Map<String, dynamic>,
          ),
        ),
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
    });
    test('it create WorkerProfiles', () async {
      expect(
        WorkerProfile(
          WorkerKey.fromJson(
            jsonDecode(qrDataShortKey) as Map<String, dynamic>,
          ),
        ),
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
    });

    test('it check date of last sync before sync on load', () async {
      final wKey = wKeysData2();

      final httpClient = AppData().httpClient as mock.MockClient;
      await AppData.instance.addProfileFromKey(wKey);
      await AppData.instance.profiles.first.postInit();
      await AppData.instance.profiles.first.postInit();
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
    });
    test('it always sync old data on load', () async {
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());

      final httpClient = AppData().httpClient as mock.MockClient;
      await AppData.instance.addProfileFromKey(wKey);
      await AppData.instance.profiles.first
          .setClientSyncDate(newDate: DateTime(1900));
      await AppData.instance.profiles.first
          .setClientPlanSyncDate(newDate: DateTime(1900));
      await AppData.instance.profiles.first
          .setServicesSyncDate(newDate: DateTime(1900));
      await AppData.instance.profiles.first.postInit();
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 2);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 2);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
    });
    test('it create list of clients with list of services', () async {
      // crete worker profile
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());
      await AppData.instance.addProfileFromKey(wKey);
      // test http
      final httpClient = AppData().httpClient as mock.MockClient;
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
      // test profile
      expect(AppData.instance.profiles.first.clients.length, 10);
      expect(AppData.instance.profiles.first.clients.first.contractId, 1);
      final client = AppData.instance.profiles.first.clients.first;
      // test service
      final service3 = client.services[3];
      expect(service3.plan, 104);
      expect(service3.shortText, 'Покупка продуктов питания');
      expect(service3.image, 'grocery-cart.png');
    });
  });
}
