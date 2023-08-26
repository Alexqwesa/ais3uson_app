import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show MockServer;
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart'
    as mock;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http show Response;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions/client_service_extension.dart';
import 'helpers/extensions/journal_extension.dart';
import 'helpers/extensions/worker_extension.dart';
import 'helpers/fake_path_provider_platform.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  //
  // > Setup
  //
  tearDownAll(() async {
    // await tearDownRealHive();
  });
  setUpAll(() async {
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
  group('Journal', () {
    test('it add services, with different states', () async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, httpClient) = await openRefContainer();
      // ----
      //
      // > configure http request as successful
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      //
      // > start test
      //
      await wp.postInit();
      // ref.refresh(hiveRepositoryProvider(wp.apiKey));
      await ref.pump();
      expect(
        wp.clients[0].services[0].deleteAllowedOf,
        false,
      );
      await wp.clients[0].services[0].add();

      expect(wp.clients[0].services[0].fullStateOf, [1, 0, 0]);
      //
      // > configure addition stale
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('', 400));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].fullStateOf, [1, 1, 0]);
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 2}', 200));
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].fullStateOf, [2, 0, 0]);
      //
      // > configure addition rejected
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 0}', 200));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].fullStateOf, [2, 0, 1]);
      expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 4);
      // wp.dispose();
    });
    //
    // > test addition of services
    //
    test('it test hive', () async {
      //
      // > prepare
      //
      final addedService =
          autoServiceOfJournal(servId: 829, contractId: 1, workerId: 1);
      final errorService = addedService.copyWith(
        state: ServiceState.rejected,
      );
      final wKey = wKeysData2();
      var hive =
          await Hive.openBox<ServiceOfJournal>('test_journal_${wKey.apiKey}');
      await hive.add(addedService);
      await hive.add(errorService);
      expect(errorService.state, ServiceState.rejected);
      //
      // > test hive
      //
      expect(hive.values.first.uid, addedService.uid);
      expect(hive.values.last.state, ServiceState.rejected);
      // Hive didn't store date on in tests?
      // await hive.flush(); // memory storage didn't store data
      // await hive.close();
      // expect(hive.isOpen, false);
      hive =
          await Hive.openBox<ServiceOfJournal>('test_journal_${wKey.apiKey}');
      expect(hive.isOpen, true);
      expect(
        hive.values.last.state,
        ServiceState.rejected,
      );
      expect(hive.values.first.state, ServiceState.added);
      expect(hive.values.last.uid, errorService.uid);
      // await hive.clear();
      // await hive.close();
    });

    test('it add new serviceOfJournal to journal', () async {
      final wKey = wKeysData2();
      //
      // > prefill hive with services
      //
      final addedService = autoServiceOfJournal(
        servId: 829,
        contractId: 1,
        workerId: 1,
      );
      final errorService = addedService.copyWith(
        state: ServiceState.rejected,
      );
      final hive =
          await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.clear(); // ???
      expect(hive.values.length, 0);
      await hive.add(addedService);
      await hive.add(errorService);
      await hive.add(addedService.copyWith(servId: 828, uid: '123'));
      await hive.add(errorService.copyWith(servId: 828, uid: '123456'));
      expect(hive.values.length, 4);
      expect(errorService.state, ServiceState.rejected);
      //
      // > prepare ProviderContainer + httpClient + worker
      final (_, _, wp, httpClient) = await openRefContainer();
      // ----
      // delayed init, should look like values were loaded from hive
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await wp.postInit();
      //
      // > start journal test
      //
      expect(wp.hiveRepository.openHive.requireValue.values.last.state,
          ServiceState.rejected);
      expect(wp.clients[0].services[1].fullStateOf, [0, 1, 1]);
      expect(wp.clients[0].services[0].fullStateOf, [0, 1, 1]);
      expect(wp.clients[0].services[0].deleteAllowedOf, true);
      await wp.clients[0].services[0].delete();
      expect(wp.clients[0].services[0].fullStateOf, [0, 1, 0]);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].fullStateOf, [2, 0, 0]);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].fullStateOf, [3, 0, 0]);
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].fullStateOf, [3, 0, 0]);
      expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 4);
      // wp.dispose();
    });

    test('it archive yesterday services', () async {
      final wKey = wKeysData2();
      //
      // > prepare
      //
      final todayService =
          autoServiceOfJournal(servId: 829, contractId: 1, workerId: 1);
      final yesterday = DateTime.now().add(const Duration(days: -1));
      final yesterdayService = todayService.copyWith(
        servId: 828,
        provDate: yesterday,
        state: ServiceState.finished,
        uid: uuid.v4(),
      );
      var hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(yesterdayService);
      await hive.add(todayService);
      expect(yesterdayService.provDate, yesterday);
      expect(yesterdayService.state, ServiceState.finished);
      //
      // > test hive
      //
      expect(hive.values.first.uid, yesterdayService.uid);
      // await hive.flush();
      // await hive.close();
      // expect(hive.isOpen, false);
      hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      expect(hive.values.length, 2);
      //
      // > init workerProfile
      //
      // > prepare ProviderContainer + httpClient + worker
      final (_, _, wp, _) = await openRefContainer();
      // ----
      await wp.postInit();
      //
      // > test what yesterday services are in archive
      //
      expect(
        wp.journal.added.first.uid,
        todayService.uid,
      );
      final hiveArchive = await Hive.openBox<ServiceOfJournal>(
        'journal_archive_${wp.apiKey}',
      );
      expect(hiveArchive.length, 1);
      expect(wp.hiveRepository.openHive.requireValue.length, 1); // only today
    });

    test('it write objects into hive', () async {
      final wKey = wKeysData2();
      //
      // > put to hive
      //
      final hive =
          await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.clear(); // ?
      expect(hive.values.length, 0);
      for (var i = 0; i < 20; i++) {
        await hive
            .add(autoServiceOfJournal(servId: 830, contractId: 1, workerId: 1));
      }

      expect(hive.values.length, 20);
      await hive.close();
    });

    test(
      'it store only hiveArchiveLimit number of services in archive',
      () async {
        //
        // > prepare ProviderContainer + httpClient
        //
        final wKey = wKeysData2();
        //
        // > prepare
        //
        final yesterday = DateTime.now().add(const Duration(days: -1));
        //
        // > put to hive
        //
        final hive =
            await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
        await hive.clear(); // ??
        expect(hive.values.length, 0);
        for (var i = 0; i < 20; i++) {
          final service = autoServiceOfJournal(
            servId: 830,
            contractId: 1,
            workerId: 1,
            provDate: yesterday,
            state: ServiceState.finished,
          );
          await hive.add(service);
          await service.save();

          final service2 =
              autoServiceOfJournal(servId: 830, contractId: 1, workerId: 1);
          await hive.add(service2);
          await service2.save();
        }

        expect(hive.values.length, 40);
        // await hive.close(); // memory storage drop on close
        //
        // > init workerProfile
        //
        // > prepare ProviderContainer + httpClient + worker
        final (ref, _, wp, _) = await openRefContainer();
        // ----
        ref.read(journalArchiveSizeProvider.notifier).state = 10;
        //
        // > test that yesterday services are in archive
        //
        await wp.journal.hiveRepository.future();
        await wp.journal.postInit();
        final hiveOfJournal = wp.journal.hiveRepository.openHive;
        expect(
          hiveOfJournal.requireValue.length,
          20,
        );
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${wp.apiKey}',
        );
        expect(hiveArchive.length, 10);
      },
    );

    test('it add new services to a client', () async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, wKey, wp, httpClient) = await openRefContainer();
      // ----
      //
      // > init workerProfile
      //
      ref.read(journalArchiveSizeProvider.notifier).state = 10;
      await wp.postInit();
      expect(ref.read(workerByApiProvider(wKey.apiKey)).name, wKey.name);
      // add services
      final client = wp.clients.first;
      expect(client.workerProfile.name, wKey.name);
      final service3 = client.services[3];
      expect(service3.shortText, 'Покупка продуктов питания');
      expect(service3.apiKey, wKey.apiKey);
      // await ref.pump();
      await service3.add();
      await ref.pump();
      await service3.add();
      await ref.pump();
      await service3.add();
      await ref.pump();
      await service3.add();
      await ref.pump();
      expect(service3.fullStateOf, [0, 4, 0]);
      await client.workerProfile.journal.commitAll();
      expect(service3.fullStateOf, [0, 4, 0]);
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await client.workerProfile.journal.commitAll();
      expect(service3.fullStateOf, [4, 0, 0]);
    });

    test('it add new services only to one client', () async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, wKey, wp, _) = await openRefContainer();
      // ----
      ref.read(journalArchiveSizeProvider.notifier).state = 10;
      await wp.postInit();
      // check worker profile
      expect(wKey, isA<WorkerKey>());
      // add services
      final client = wp.clients.first;
      final client2 = wp.clients[2];
      final service3 = client.services[3];
      expect(service3.shortText, 'Покупка продуктов питания');
      when(
        MockServer(
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient,
        ).testReqPostAdd,
      ).thenAnswer((_) async {
        throw StateError('timeout as expected');
      });
      await service3.add();
      await ref.pump();
      await service3.add();
      await ref.pump();
      await service3.add();
      await ref.pump();
      expect(service3.fullStateOf, [0, 3, 0]);
      expect(client2.services[3].shortText, 'Покупка продуктов питания');
      expect(client2.services[3].fullStateOf, [0, 0, 0]);
    });

    test(
      'it add and delete services in order:rejected->added->finished->outDated',
      () async {
        // > prepare ProviderContainer + httpClient + worker
        final (ref, _, wp, httpClient) = await openRefContainer();
        // ----
        ref.read(journalArchiveSizeProvider.notifier).state = 10;
        // await wp.journal.hiveRepository.future(); // to postInit ?
        await wp.postInit();
        // add services
        final client = wp.clients.first;
        final service3 = client.services[3];
        //
        // > add 10 service
        //
        // await ref.pump();
        const servNum = 10;
        for (var i = 0; i < servNum; i++) {
          await service3.add();
          // await ref.pump();
          expect(
              verify(MockServer(httpClient).testReqPostAdd).callCount, i + 1);
        }
        expect(service3.fullStateOf, [0, 10, 0]);
        //
        // > allow add services
        //
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 1}', 200));
        await client.workerProfile.journal.commitAll();
        expect(
            verify(MockServer(httpClient).testReqPostAdd).callCount, servNum);
        expect(service3.fullStateOf, [10, 0, 0]);
        expect(client.workerProfile.journal.finished.length, 10);

        //
        // > mark outdated
        //
        // service3.servicesInJournal.forEach((element) {
        //   element.provDate.add(const Duration(hours: -2));
        // });
        // client.workerProfile.services.clear();

        await service3.workerProfile.syncPlanned();
        expect(verify(MockServer(httpClient).testReqGetPlanned).callCount, 2);
        expect(client.workerProfile.journal.finished.length, 10);
        await client.workerProfile.journal.updateBasedOnNewPlanDate();
        expect(client.workerProfile.journal.outDated.length, 10);
        expect(service3.fullStateOf, [10, 0, 0]);

        //
        // > add 10 finished
        //
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        await ref.pump();
        expect(service3.fullStateOf, [20, 0, 0]);
        expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 10);
        //
        // > add 10 rejected
        //
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 0}', 200));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(service3.fullStateOf, [20, 0, 10]);
        expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 10);
        //
        // > add 10 stale
        //
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('', 500));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(service3.fullStateOf, [20, 10, 10]);
        verifyNever(MockServer(httpClient).testReqGetPlanned);
        expect(
          verify(MockServer(httpClient).testReqPostAdd).callCount,
          (servNum + 1) * (servNum / 2),
        );
        //
        // > delete
        //
        when(MockServer(httpClient).testReqDelete)
            .thenAnswer((_) async => http.Response('{"id": 0}', 200));
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.fullStateOf, [20, 10, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.fullStateOf, [20, 0, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }

        expect(service3.fullStateOf, [10, 0, 0]);
        expect(client.workerProfile.journalOf.outDated.length, 10);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.fullStateOf, [0, 0, 0]);
        expect(verify(MockServer(httpClient).testReqDelete).callCount, 20);

        // await service3.add();
        // expect(service3.fullStateOf, [10, 1, 0]);
        // expect(verify(MockServer(httpClient).testReqDelete).callCount, 10);
      },
    );
  });
}
