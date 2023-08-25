// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http show Response;
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
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
        // > prepare ProviderContainer + httpClient + worker
        final (ref, _, wp, httpClient) = await openRefContainer();
        // ----
        await tester.runAsync<void>(() async {
          await wp.postInit();
        });
        // add service
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 2}', 200));
        final service =
            ref.read(departmentsProvider).first.clients.first.services.first;
        await tester.runAsync<void>(() async {
          await service.add();
          await service.add();
        });
        // check widget
        const widgetForTesting = ArchiveServicesOfClientScreen();
        await tester.pumpWidget(
          ProviderScope(
            parent: ref,
            overrides: [
              currentClient.overrideWithValue(
                  ref.read(departmentsProvider).first.clients.first)
            ],
            child: localizedMaterialApp(
              widgetForTesting,
              ref,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining(service.shortText), findsWidgets);
        expect(
          find.textContaining(ref
              .read(departmentsProvider)
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
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, _, httpClient) = await openRefContainer();
      // ----
      await tester.runAsync<void>(() async {
        await ref.read(departmentsProvider).first.postInit();
      });
      // add service
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 2}', 200));
      final service =
          ref.read(departmentsProvider).first.clients.first.services[3];
      await tester.runAsync<void>(() async {
        await service.add();
        // await service.add();
        // await service.add();
      });
      //
      // > add proof
      //

      //why it doesn't work in batch tests
      final tmpFile = File(
              '${Directory.current.path}/test/helpers/auth_qr_test.png'
                  .replaceAll('/', Platform.pathSeparator))
          .copySync(path.join(Directory.systemTemp.path, 'auth_qr_test5.png'));

      final file = XFile(tmpFile.path);
      late int flen; // for butch test we need 0this runAsync
      await tester.runAsync<void>(() async {
        flen = await file.length();
      });
      expect(flen > 0, true);

      // final srcFileLength = await file.length();
      // expect(srcFileLength > 0, true);
      await tester.runAsync<void>(() async {
        final (_, proofs) = ref.read(service.proofsOf);
        proofs.addProof(); // serv.addProof();
        await proofs.addImage(0, file, 'before_');
        final _ = proofs.proofs.first.before.image; // why ???
      });
      final (_, proofController) = ref.read(service.proofsOf);
      //
      // > check: image created
      //
      expect(
        proofController.proofs.first.before.image?.toStringShort(),
        'Image',
      );

      expect(proofController.proofs.length, 1);
      //
      // > check ClientServiceScreen
      //
      final newService = service.copyWith(
        date: DateTimeExtensions.today(), //instead of null,
      );
      await tester.runAsync<void>(() async {
        await newService.proofs
            .loadProofsFromFS(); // didn't work, without runAsync
      });

      final widgetForTesting = ProviderScope(
        overrides: [
          currentService.overrideWithValue(
            newService,
          ),
        ],
        child: const ClientServiceScreen(),
      );
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
            ref,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(service.servTextAdd), findsOneWidget);
      final proof = service.proofs.proofs.first;
      expect(
        find.byKey(ValueKey(
          '${proof.name}___before_',
        )),
        findsOneWidget,
      );
      //
      // > check: file created
      //
      // final appDocDir = Directory(
      //   '${(await getApplicationDocumentsDirectory()).path}/Ais3uson',
      // );
      //
      // final dstFile = File(
      //   // ignore: prefer_interpolation_to_compose_strings
      //   ('${appDocDir.path}/1_Работник Тестового Отделения 2/1_Тес. . чек/' +
      //           standardFormat.format(DateTime.now()) +
      //           '_/831_Покупка продуктов питания/group_0_/before_img_auth_qr_test5.png')
      //       .replaceAll('/', Platform.pathSeparator)
      //       .replaceAll(' ', ''),
      // );
      // expect(await dstFile.length() > 0, true);
      // // cleanup
      // dstFile.deleteSync();
    });
  });
}
