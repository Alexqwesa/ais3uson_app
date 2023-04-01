import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/helpers/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/providers/settings/hive_archive_size.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show MockServer, getMockHttpClient;
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart'
    as mock;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http show Response;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_models_test.dart';

void main() {
  //
  // > Setup
  //
  tearDownAll(() async {
    await tearDownTestHive();
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
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      //
      // > configure http request as successful
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      //
      // > start test
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref
          .read(workerProfiles)
          .firstWhere((element) => element.apiKey == wKey.apiKey);
      await wp.postInit();
      expect(
        ref.read(deleteAllowedOfService(wp.clients[0].services[0])),
        false,
      );
      await wp.clients[0].services[0].add();

      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [1, 0, 0]);
      //
      // > configure addition stale
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('', 400));
      await wp.clients[0].services[0].add();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [1, 1, 0]);
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 2}', 200));
      await wp.journal.commitAll();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [2, 0, 0]);
      //
      // > configure addition rejected
      //
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 0}', 200));
      await wp.clients[0].services[0].add();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [2, 0, 1]);
      expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 4);
      // wp.dispose();
    });
    //
    // > test addition of services
    //
    test('it load serviceOfJournal from Hive', () async {
      //
      // > prepare
      //
      final addedService =
          autoServiceOfJournal(servId: 829, contractId: 1, workerId: 1);
      final errorService = addedService.copyWith(
        state: ServiceState.rejected,
      );
      final wKey = wKeysData2();
      var hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(addedService);
      await hive.add(errorService);
      expect(errorService.state, ServiceState.rejected);
      //
      // > test hive
      //
      expect(hive.values.first.uid, addedService.uid);
      expect(hive.values.last.state, ServiceState.rejected);
      // Hive didn't store date on in tests?
      await hive.flush();
      await hive.close();
      expect(hive.isOpen, false);
      hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      expect(
        hive.values.last.state,
        ServiceState.rejected,
      );
      expect(hive.values.first.state, ServiceState.added);
      expect(hive.values.last.uid, errorService.uid);
    });

    test('it add new serviceOfJournal to journal', () async {
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
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
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
      await hive.add(addedService);
      await hive.add(errorService);
      await hive.add(addedService.copyWith(servId: 828, uid: '123'));
      await hive.add(errorService.copyWith(servId: 828, uid: '123456'));
      expect(hive.values.length, 4);
      expect(errorService.state, ServiceState.rejected);
      //
      // > init WorkerProfile and mock http
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref
          .read(workerProfiles)
          .firstWhere((element) => element.apiKey == wKey.apiKey);
      // delayed init, should look like values were loaded from hive
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await wp.postInit();
      //
      // > start journal test
      //
      expect(wp.journal.hive.values.last.state, ServiceState.rejected);
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[1])), [0, 1, 1]);
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [0, 1, 1]);
      expect(ref.read(deleteAllowedOfService(wp.clients[0].services[0])), true);
      await wp.clients[0].services[0].delete();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [0, 1, 0]);
      await wp.clients[0].services[0].add();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [2, 0, 0]);
      await wp.clients[0].services[0].add();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [3, 0, 0]);
      await wp.journal.commitAll();
      expect(ref.read(doneStaleErrorOf(wp.clients[0].services[0])), [3, 0, 0]);
      expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 4);
      // wp.dispose();
    });

    test('it archive yesterday services', () async {
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
      await hive.flush();
      await hive.close();
      expect(hive.isOpen, false);
      hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      expect(hive.values.length, 2);
      //
      // > init workerProfile
      //
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
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
      expect(wp.journal.hive.values.length, 1);
      expect(hiveArchive.length, 1);
    });

    test(
      'it store only hiveArchiveLimit number of services in archive',
      () async {
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
        // > prepare
        //
        final yesterday = DateTime.now().add(const Duration(days: -1));
        //
        // > put to hive
        //
        final hive =
            await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
        for (var i = 0; i < 20; i++) {
          await hive.add(
            autoServiceOfJournal(
              servId: 830,
              contractId: 1,
              workerId: 1,
              provDate: yesterday,
              state: ServiceState.finished,
            ),
          );
          await hive.add(
            autoServiceOfJournal(servId: 830, contractId: 1, workerId: 1),
          );
        }
        //
        // > init workerProfile
        //
        ref.read(hiveArchiveSize.notifier).state = 10;
        ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
        final wp = ref.read(workerProfiles).first;
        // await AppData.instance
        //
        // > test that yesterday services are in archive
        //
        await wp.journal.postInit();
        expect(
          wp.journal.hive.values.length,
          20,
        );
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${wp.apiKey}',
        );
        expect(hiveArchive.length, 10);
      },
    );

    test('it add new services to a client', () async {
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
      final httpClient =
          ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
      //
      // > init workerProfile
      //
      ref.read(hiveArchiveSize.notifier).state = 10;
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await wp.postInit();
      // check worker profile
      expect(wKey, isA<WorkerKey>());
      // add services
      final client = wp.clients.first;
      final service3 = client.services[3];
      expect(service3.shortText, 'Покупка продуктов питания');
      await service3.add();
      await service3.add();
      await service3.add();
      await service3.add();

      expect(ref.read(doneStaleErrorOf(service3)), [0, 4, 0]);
      await client.workerProfile.journal.commitAll();
      expect(ref.read(doneStaleErrorOf(service3)), [0, 4, 0]);
      when(MockServer(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await client.workerProfile.journal.commitAll();
      expect(ref.read(doneStaleErrorOf(service3)), [4, 0, 0]);
    });

    test('it add new services only to one client', () async {
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
      ref.read(hiveArchiveSize.notifier).state = 10;
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
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
      await service3.add();
      await service3.add();
      expect(ref.read(doneStaleErrorOf(service3)), [0, 3, 0]);
      expect(client2.services[3].shortText, 'Покупка продуктов питания');
      expect(ref.read(doneStaleErrorOf(client2.services[3])), [0, 0, 0]);
    });

    test(
      'it add and delete services in order:rejected->added->finished->outDated',
      () async {
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
        final httpClient =
            ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
        //
        // > init workerProfile
        //
        ref.read(hiveArchiveSize.notifier).state = 10;
        ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
        final wp = ref.read(workerProfiles).first;
        await wp.postInit();
        // add services
        final client = wp.clients.first;
        final service3 = client.services[3];
        const servNum = 10;
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        //
        // > add 10 service
        //
        expect(ref.read(doneStaleErrorOf(service3)), [0, 10, 0]);
        expect(
          verify(MockServer(httpClient).testReqPostAdd).callCount,
          (servNum + 1) * (servNum / 2),
        );
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 1}', 200));
        await client.workerProfile.journal.commitAll();
        expect(ref.read(doneStaleErrorOf(service3)), [10, 0, 0]);
        expect(client.workerProfile.journal.finished.length, 10);
        //
        // > mark outdated
        //
        // service3.servicesInJournal.forEach((element) {
        //   element.provDate.add(const Duration(hours: -2));
        // });
        // client.workerProfile.services.clear();
        await service3.workerProfile.syncPlanned();
        expect(client.workerProfile.journal.finished.length, 10);
        await client.workerProfile.journal.updateBasedOnNewPlanDate();
        expect(client.workerProfile.journal.outDated.length, 10);
        expect(ref.read(doneStaleErrorOf(service3)), [10, 0, 0]);
        //
        // > add 10 finished
        //
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        await ref.pump();
        expect(ref.read(doneStaleErrorOf(service3)), [20, 0, 0]);
        expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 20);
        //
        // > add 10 rejected
        //
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 0}', 200));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(ref.read(doneStaleErrorOf(service3)), [20, 0, 10]);
        expect(verify(MockServer(httpClient).testReqPostAdd).callCount, 10);
        //
        // > add 10 stale
        //
        when(MockServer(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('', 500));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(ref.read(doneStaleErrorOf(service3)), [20, 10, 10]);
        expect(verify(MockServer(httpClient).testReqGetPlanned).callCount, 2);
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
        expect(ref.read(doneStaleErrorOf(service3)), [20, 10, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(ref.read(doneStaleErrorOf(service3)), [20, 0, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(ref.read(doneStaleErrorOf(service3)), [10, 0, 0]);
        expect(
          ref.read(journalOfWorker(client.workerProfile)).outDated.length,
          10,
        );
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(ref.read(doneStaleErrorOf(service3)), [0, 0, 0]);
        expect(verify(MockServer(httpClient).testReqDelete).callCount, 20);
      },
    );
  });
}
