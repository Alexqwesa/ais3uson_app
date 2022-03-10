import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'helpers/mock_server.dart' show ExtMock, getMockHttpClient;
import 'helpers/mock_server.mocks.dart' as mock;

/// [WorkerKey] modified for tests (ssl='no')
WorkerKey wKeysData2() {
  final json = jsonDecode(qrData2WithAutossl) as Map<String, dynamic>;
  // json['ssl'] = 'no';

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
    Singleton.register(AppData);
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
    test('it create proof file', () async {
      // crete worker profile
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());
      await AppData.instance.postInit();
      await AppData.instance.addProfileFromKey(wKey);
      // add proof
      File('${Directory.current.path}/test/helpers/auth_qr_test.png').copySync(
        '${Directory.systemTemp.path}/auth_qr_test.png',
      );
      final file = XFile('${Directory.systemTemp.path}/auth_qr_test.png');
      expect((await file.length()) > 0, true);
      final serv = AppData.instance.profiles.first.clients.first.services.first;
      serv.proofList.addNewGroup(); // serv.addProof();
      await serv.proofList.addImage(0, file, 'before_');
      // Image is created
      expect(
        serv.proofList.proofGroups.first.beforeImg?.toStringShort(),
        'Image',
      );
    });
    test('it can found proof files', () async {
      // crete worker profile
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());
      await AppData.instance.postInit();
      await AppData.instance.addProfileFromKey(wKey);
      final appDocDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/Ais3uson',
      );
      final dst = Directory(
        '${appDocDir.path}/1_Работник Тестового Отделения 2/1_Тес  чек/01.03.2022_/828_Итого/group_0_/',
      );
      if (!dst.existsSync()) {
        dst.createSync(recursive: true);
      }
      // add proof
      final file =
          File('${Directory.current.path}/test/helpers/auth_qr_test.png')
              .copySync(
        '${dst.path}/before_img_auth_qr_test.png',
      );
      final serv2 =
          AppData.instance.profiles.first.clients.first.services.first;
      expect(serv2.proofList.proofGroups.length, 0);
      await serv2.proofList.crawler();
      // Image is founded

      expect(serv2.proofList.proofGroups.isNotEmpty, true);
      expect(
        serv2.proofList.proofGroups.first.beforeImg?.toStringShort(),
        'Image',
      );
      file.deleteSync();
    });
  });
}
