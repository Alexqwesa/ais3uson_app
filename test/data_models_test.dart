import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await tearDownTestHive();
  });
  setUpAll(() async {
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });
  //
  // > Tests start
  //
  group('Data Models', () {
    test('it create WorkerProfiles', () async {
      final ref = ProviderContainer();
      ref.read(workerProfiles.notifier).addProfileFromKey(
            WorkerKey.fromJson(
              jsonDecode(qrDataWithSSL) as Map<String, dynamic>,
            ),
          );
      expect(
        ref.read(workerProfiles).first,
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
    });

    test('it create WorkerProfile from short key', () async {
      final ref = ProviderContainer();
      ref.read(workerProfiles.notifier).addProfileFromKey(
            WorkerKey.fromJson(
              jsonDecode(qrDataShortKey) as Map<String, dynamic>,
            ),
          );
      expect(
        ref.read(workerProfiles).first,
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
    });

    test('it check date of last sync before sync on load', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await wp.postInit();
      // await ref.pump();
      expect(wp.clients.length, 10);
      expect(wp.services.length, 272);
      expect(wp.clientPlan.length, 500);
      final httpClient =
          ref.read(httpClientProvider(wKey.certificate)) as mock.MockClient;
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
    });

    test('it always sync old data on load', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(workerProfiles).first;
      final httpClient =
          ref.read(httpClientProvider(wKey.certificate)) as mock.MockClient;
      await wp.postInit();
      await wp.postInit(); // second call - should do nothing
      //
      // > reset sync dates
      //
      await wp.syncPlanned();
      // skip services update
      // await wp.syncHiveServices();
      await wp.syncClients();
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 2);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 2);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
    });

    test('it create list of clients with list of services', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(workerProfiles).first;
      final httpClient =
          ref.read(httpClientProvider(wKey.certificate)) as mock.MockClient;
      await wp.postInit();
      // test http
      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(ExtMock(httpClient).testReqGetServices).callCount, 1);
      // test profile
      expect(wp.clients.length, 10);
      expect(wp.clients.first.contractId, 1);
      final client = wp.clients.first;
      // test service
      final service3 = client.services[3];
      expect(service3.plan, 104);
      expect(service3.shortText, '?????????????? ?????????????????? ??????????????');
      expect(service3.image, 'grocery-cart.png');
    });

    test('it create proof file', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(workerProfiles).first;
      await wp.postInit();
      //
      // > add proof
      //
      File(path.join(
        Directory.current.path,
        'test',
        'helpers',
        'auth_qr_test.png',
      )).copySync(
        path.join(Directory.systemTemp.path, 'auth_qr_test.png'),
      );
      final file =
          XFile(path.join(Directory.systemTemp.path, 'auth_qr_test.png'));
      final srcFileLength = await file.length();
      expect(srcFileLength > 0, true);
      final serv = wp.clients.first.services.first;
      serv.proofList.addNewGroup(); // serv.addProof();
      await serv.proofList.addImage(0, file, 'before_');
      //
      // > check: image created
      //
      expect(
        serv.proofList.proofGroups.first.beforeImg?.toStringShort(),
        'Image',
      );
      //
      // > check: file created
      //
      final appDocDir = Directory(
        path.join(
          (await getApplicationDocumentsDirectory()).path,
          'Ais3uson',
        ),
      );
      final dstFile = File(
        // ignore: prefer_interpolation_to_compose_strings
        ('${appDocDir.path}/1_???????????????? ?????????????????? ?????????????????? 2/1_??????. . ??????/' +
                standardFormat.format(DateTime.now()) +
                '_/828_??????????/group_0_/before_img_auth_qr_test.png')
            .replaceAll('/', Platform.pathSeparator)
            .replaceAll(' ', ''),
      );
      expect(
        await dstFile.length(),
        srcFileLength,
      );
      // cleanup
      dstFile.deleteSync(); // todo: delete folder too (if empty)
    });

    test('it can found proof files', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(workerProfiles).first;
      ref.read(archiveDate.notifier).state = DateTime(2022, 3);
      await wp.postInit();
      //
      // > create dir for proof
      //
      final appDocDir = Directory(
        path.join(
          (await getApplicationDocumentsDirectory()).path,
          'Ais3uson',
        ),
      );
      final dst = Directory(
        '${appDocDir.path}/1_???????????????? ?????????????????? ?????????????????? 2/1_??????. . ??????/01.03.2022_/828_??????????/group_0_/'
            .replaceAll('/', Platform.pathSeparator)
            .replaceAll(' ', ''),
      );
      if (!dst.existsSync()) {
        dst.createSync(recursive: true);
      }
      // add proof

      final file = File(path.join(
        Directory.current.path,
        'test',
        'helpers',
        'auth_qr_test.png',
      )).copySync(
        path.join(dst.path, 'before_img_auth_qr_test.png'),
      );
      final serv2 = wp.clients.first.services.first;
      expect(serv2.proofList.proofGroups.length, 0); // can be raced?
      // await serv2.proofList.crawler();
      await serv2.proofList.crawled;
      expect(serv2.proofList.proofGroups.length, 1);
      // Image is founded
      expect(serv2.proofList.proofGroups.isNotEmpty, true);
      // await serv2.proofList.crawled;
      expect(
        serv2.proofList.proofGroups.first.beforeImg?.toStringShort(),
        'Image',
      );
      file.deleteSync();
    });
  });
}
