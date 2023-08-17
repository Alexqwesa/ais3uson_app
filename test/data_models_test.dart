import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show MockServer, getMockHttpClient;
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart'
    as mock;
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_path_provider_platform.dart';
import 'helpers/setup_and_teardown_helpers.dart';
import 'helpers/worker_profile_test_extensions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //
  // > Setup
  //
  tearDownAll(() async {
    await tearDownTestHive();
  });
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    SharedPreferences.setMockInitialValues({});
    await init();
    // WidgetsFlutterBinding.ensureInitialized();
    // DartPluginRegistrant.ensureInitialized();

    // const channel = MethodChannel('plugins.flutter.io/path_provider');
    // channel.setMockMethodCallHandler((MethodCall methodCall) async {
    //   return "/tmp/unit_tests";
    // });
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    //
    // > locator
    //
    await locator.reset();
    final sharedPreferences = await SharedPreferences.getInstance();
    locator
      ..registerLazySingleton<S>(S.new)
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
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
      ref.read(departmentsProvider.notifier).addProfileFromKey(
            WorkerKey.fromJson(
              jsonDecode(qrDataShortKey) as Map<String, dynamic>,
            ),
          );
      expect(
        ref.read(departmentsProvider).first,
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
    });

    test('it create WorkerProfile from short key', () async {
      final ref = ProviderContainer();
      ref.read(departmentsProvider.notifier).addProfileFromKey(
            WorkerKey.fromJson(
              jsonDecode(qrDataShortKey) as Map<String, dynamic>,
            ),
          );
      expect(
        ref.read(departmentsProvider).first,
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
      expect(ref.read(departmentsProvider).length, 1);
      ref.dispose();
    });

    test('it create only one WorkerProfiles', () async {
      final ref = ProviderContainer();
      await ref.pump();
      await ref.pump();
      await ref.pump();
      await ref.pump();

      ref.refresh(departmentsProvider);
      await ref.pump();
      // ref.refresh(workerKeys);
      expect(ref.read(departmentsProvider).length, 0);
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKeysData2());
      expect(ref.read(departmentsProvider).length, 1);
      expect(
        ref.read(departmentsProvider).first,
        isA<WorkerProfile>(),
      );
      expect(wKeysData2(), isA<WorkerKey>());
      expect(ref.read(departmentsProvider).length, 1);
    });

    test('it check date of last sync before sync on load', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKey);
      final wp = ref.read(departmentsProvider).first;
      await wp.postInit();
      // await ref.pump();
      expect(wp.clients.length, 10);
      expect(wp.services.length, 272);
      expect(wp.clientsPlan.length, 500);
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      expect(verify(MockServer(httpClient).testReqGetClients).callCount, 1);
      expect(verify(MockServer(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(MockServer(httpClient).testReqGetServices).callCount, 1);
    });

    test('it always sync old http data on load', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(departmentsProvider).first;
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      await wp.postInit();
      await wp.postInit(); // second call - should do nothing
      //
      // > reset sync dates
      //
      await wp.syncPlanned();
      // skip services update
      // await wp.syncHiveServices();
      await wp.syncClients();
      expect(verify(MockServer(httpClient).testReqGetClients).callCount, 2);
      expect(verify(MockServer(httpClient).testReqGetPlanned).callCount, 2);
      expect(verify(MockServer(httpClient).testReqGetServices).callCount, 1);
    });

    test('it create list of clients with list of services', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(departmentsProvider).first;
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      await wp.postInit();
      // test http
      expect(verify(MockServer(httpClient).testReqGetClients).callCount, 1);
      expect(verify(MockServer(httpClient).testReqGetPlanned).callCount, 1);
      expect(verify(MockServer(httpClient).testReqGetServices).callCount, 1);
      // test profile
      expect(wp.clients.length, 10);
      expect(wp.clients.first.contractId, 1);
      final client = wp.clients.first;
      // test service
      final service3 = client.services[3];
      expect(service3.plan, 104);
      expect(service3.shortText, 'Покупка продуктов питания');
      expect(service3.image, 'grocery-cart.png');
    });

    test('it create proof file', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKeysData2());

      final wp = ref.read(departmentsProvider).first;
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
      serv.proofs.addProof(); // serv.addProof();
      await serv.proofs.addImage(0, file, 'before_');
      //
      // > check: image created
      //
      expect(
        serv.proofs.proofs.first.before.image?.toStringShort(),
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
        ('${appDocDir.path}/1_Работник Тестового Отделения 2/1_Тес. . чек/' +
                standardFormat.format(DateTime.now()) +
                '_/828_Итого/group_0_/before_img_auth_qr_test.png')
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

    // path_provider didn't work in tests anymore
    test('it can access filesystem', () async {
      final dir = await getSafePath(['']);
      expect(dir, isNot(null));
    });

    test('it can found proof files', () async {
      //
      // > prepare ProviderContainer + httpClient
      //
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      //
      // > init workerProfile
      //
      ref.read(departmentsProvider.notifier).addProfileFromKey(wKeysData2());
      final wp = ref.read(departmentsProvider).first;
      ref.read(archiveDate.notifier).state = DateTime(2022, 3);
      await wp.postInit();

      if (kIsWeb) return; // todo:
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
        '${appDocDir.path}/1_Работник Тестового Отделения 2/1_Тес. . чек/01.03.2022_/828_Итого/group_0_/'
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
      expect(serv2.proofs.proofs.length, 0); // can be raced?
      // await serv2.proofList.crawler();
      await serv2.proofs.loadedFromFS;
      expect(serv2.proofs.proofs.length, 1);
      // Image is founded
      expect(serv2.proofs.proofs.isNotEmpty, true);
      // await serv2.proofList.crawled;
      expect(
        serv2.proofs.proofs.first.before.image?.toStringShort(),
        'Image',
      );
      file.deleteSync();
    });
  });
}
