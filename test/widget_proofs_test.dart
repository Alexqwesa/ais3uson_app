// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart'
    as mock;
import 'package:ais3uson_app/ui_services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http show Response;
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

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
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    locator.pushNewScope();
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  //
  // > Tests start
  //
  group('Proofs at date', () {
    testWidgets(
      'it show one service in AllServicesOfClientScreen',
      (tester) async {
        // init ref
        final wKey = wKeysData2();
        final ref = ProviderContainer(
          overrides: [
            httpClientProvider(wKey.certBase64)
                .overrideWithValue(getMockHttpClient()),
          ],
        );
        // add Profile
        ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
        final wp = ref.read(workerProfiles).first;
        await tester.runAsync<void>(() async {
          await wp.postInit();
        });
        // add service
        final httpClient =
            ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 2}', 200));
        final service =
            ref.read(workerProfiles).first.clients.first.services.first;
        await tester.runAsync<void>(() async {
          await service.add();
          await service.add();
        });
        // check widget
        const widgetForTesting = ArchiveServicesOfClientScreen();
        await tester.pumpWidget(
          ProviderScope(
            parent: ref,
            child: localizedMaterialApp(
              widgetForTesting,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining(service.shortText), findsWidgets);
        expect(
          find.textContaining(ref
              .read(workerProfiles)
              .first
              .clients
              .first
              .services
              .last
              .shortText),
          findsNothing,
        );
      },
    );

    testWidgets('it show proof at date', (tester) async {
      // init ref
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certBase64)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      // add Profile
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      // add service
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 2}', 200));
      final service = ref.read(workerProfiles).first.clients.first.services[3];
      await tester.runAsync<void>(() async {
        await service.add();
        // await service.add();
        // await service.add();
      });
      //
      // > add proof
      //
      File('${Directory.current.path}/test/helpers/auth_qr_test.png'
              .replaceAll('/', Platform.pathSeparator))
          .copySync(path.join(Directory.systemTemp.path, 'auth_qr_test.png'));
      final file = XFile('${Directory.systemTemp.path}/auth_qr_test.png');
      // final srcFileLength = await file.length();
      // expect(srcFileLength > 0, true);
      service.proofList.addNewGroup(); // serv.addProof();
      await tester.runAsync<void>(() async {
        await service.proofList.addImage(0, file, 'before_');
      });

      //
      // > check: image created
      //
      expect(
        service.proofList.proofGroups.first.beforeImg?.toStringShort(),
        'Image',
      );
      //
      // > check: file created
      //
      final appDocDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/Ais3uson',
      );
      final dstFile = File(
        // ignore: prefer_interpolation_to_compose_strings
        ('${appDocDir.path}/1_Работник Тестового Отделения 2/1_Тес. . чек/' +
                standardFormat.format(DateTime.now()) +
                '_/831_Покупка продуктов питания/group_0_/before_img_auth_qr_test.png')
            .replaceAll('/', Platform.pathSeparator)
            .replaceAll(' ', ''),
      );
      expect(service.proofList.proofGroups.length, 1);
      final proofList =
          ref.read(servProofAtDate(Tuple2(DateTime.now().dateOnly(), service)));
      expect(proofList.proofGroups.length, 1);
      //
      // > check ClientServiceScreen
      //
      ref.read(lastUsed).service = service;

      final newService = service.copyWith(
        date: DateTimeExtensions.today(), //instead of null,
      );
      await tester.runAsync<void>(() async {
        await newService.proofList.crawler(); // didn't work, without runAsync
      });
      final widgetForTesting = ProviderScope(
        child: const ClientServiceScreen(),
        overrides: [
          currentService.overrideWithValue(
            newService,
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(service.servTextAdd), findsOneWidget);
      final proof = service.proofList.proofGroups.first;
      expect(
        find.byKey(ValueKey(
          '${proof.name}___before_',
        )),
        findsOneWidget,
      );

      // cleanup
      await tester.runAsync<void>(() async {
        expect(await dstFile.length() > 0, true);
        try {
          dstFile.deleteSync(); // todo: delete folder too (if empty)
          // ignore: avoid_catches_without_on_clauses, empty_catches
        } catch (e) {}
      });
    });
  });
}
