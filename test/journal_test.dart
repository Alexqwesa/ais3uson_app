import 'dart:convert';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:http/http.dart' as http show Response;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // init AppData
    await locator<AppData>().postInit();
    // httpClient setup
    locator<AppData>().httpClient = getMockHttpClient();
  });
  tearDown(() async {
    await locator.resetLazySingleton<AppData>();
    await tearDownTestHive();
  });
  //
  // > Tests start
  //
  group('Journal', () {
    test('it add services, with different states', () async {
      //
      // > prepare
      //
      final httpClient = locator<AppData>().httpClient as mock.MockClient;
      final wp = WorkerProfile(wKeysData2());
      //
      // > configure addition successful
      //
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await wp.postInit();
      //
      // > start test
      //
      expect(wp.clients[0].services[0].deleteAllowed, false);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [1, 0, 0]);
      //
      // > configure addition stale
      //
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('', 400));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [1, 1, 0]);
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 2}', 200));
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 0]);
      //
      // > configure addition rejected
      //
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 0}', 200));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 1]);
      expect(verify(ExtMock(httpClient).testReqPostAdd).callCount, 4);
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
      final addedService =
          autoServiceOfJournal(servId: 829, contractId: 1, workerId: 1);
      final errorService = addedService.copyWith(
        state: ServiceState.rejected,
      );
      final wKey = wKeysData2();
      final hive =
          await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(addedService);
      await hive.add(errorService);
      await hive.add(addedService.copyWith(servId: 828, uid: '12345'));
      await hive.add(errorService.copyWith(servId: 828, uid: '123456'));
      expect(errorService.state, ServiceState.rejected);
      //
      // > init WorkerProfile and mock http
      //
      final httpClient = locator<AppData>().httpClient
          as mock.MockClient; // as MockHttpClientLibrary;
      final wp = WorkerProfile(wKey);
      // delayed init, should look like values were loaded from hive
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await wp.postInit();
      //
      // > start journal test
      //
      expect(wp.journal.hive.values.last.state, ServiceState.rejected);
      expect(wp.clients[0].services[1].listDoneProgressError, [0, 1, 1]);
      expect(wp.clients[0].services[0].listDoneProgressError, [0, 1, 1]);
      expect(wp.clients[0].services[0].deleteAllowed, true);
      await wp.clients[0].services[0].delete();
      expect(wp.clients[0].services[0].listDoneProgressError, [0, 1, 0]);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 0]);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [3, 0, 0]);
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].listDoneProgressError, [3, 0, 0]);
      expect(verify(ExtMock(httpClient).testReqPostAdd).callCount, 4);
      // wp.dispose();
    });
    test('it archive yesterday services', () async {
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
      );
      final wKey = wKeysData2();
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
      // > init AppData
      //
      await locator<AppData>().addProfileFromKey(wKey);
      //
      // > test what yesterday services are in archive
      //
      expect(
        locator<AppData>().profiles.first.journal.added.first.uid,
        todayService.uid,
      );
      final hiveArchive = await Hive.openBox<ServiceOfJournal>(
        'journal_archive_${locator<AppData>().profiles.first.apiKey}',
      );
      expect(locator<AppData>().profiles.first.journal.hive.values.length, 1);
      expect(hiveArchive.length, 1);
    });
    test(
      'it store only hiveArchiveLimit number of services in archive',
      () async {
        //
        // > prepare
        //
        final yesterday = DateTime.now().add(const Duration(days: -1));
        //
        // > put to hive
        //
        final wKey = wKeysData2();
        final hive =
            await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
        for (var i = 0; i < 20; i++) {
          await hive.add(autoServiceOfJournal(
            servId: 830,
            contractId: 1,
            workerId: 1,
            provDate: yesterday,
            state: ServiceState.finished,
          ));
          await hive.add(
            autoServiceOfJournal(servId: 830, contractId: 1, workerId: 1),
          );
        }
        //
        // > AppData init
        //
        await locator<AppData>().postInit();
        locator<AppData>().hiveArchiveLimit = 10;
        await locator<AppData>().addProfileFromKey(wKey);
        // await AppData.instance
        //
        // > test that yesterday services are in archive
        //
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${locator<AppData>().profiles.first.apiKey}',
        );
        expect(
          locator<AppData>().profiles.first.journal.hive.values.length,
          20,
        );
        expect(hiveArchive.length, 10);
      },
    );
    test('it add new services to a client', () async {
      // crete worker profile
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());
      await locator<AppData>().addProfileFromKey(wKey);
      // add services
      final client = locator<AppData>().profiles.first.clients.first;
      final service3 = client.services[3];
      expect(service3.shortText, 'Покупка продуктов питания');
      await service3.add();
      await service3.add();
      await service3.add();

      expect(service3.listDoneProgressError, [0, 3, 0]);
      await client.workerProfile.journal.commitAll();
      expect(service3.listDoneProgressError, [0, 3, 0]);
      final httpClient = locator<AppData>().httpClient
          as mock.MockClient; // as MockHttpClientLibrary;
      when(ExtMock(httpClient).testReqPostAdd)
          .thenAnswer((_) async => http.Response('{"id": 1}', 200));
      await client.workerProfile.journal.commitAll();
      expect(service3.listDoneProgressError, [3, 0, 0]);
    });
    test('it add new services only to one client', () async {
      // crete worker profile
      final wKey = wKeysData2();
      expect(wKey, isA<WorkerKey>());
      await locator<AppData>().addProfileFromKey(wKey);
      // add services
      final client = locator<AppData>().profiles.first.clients.first;
      final client2 = locator<AppData>().profiles.first.clients[2];
      final service3 = client.services[3];
      expect(service3.shortText, 'Покупка продуктов питания');
      await service3.add();
      await service3.add();
      await service3.add();
      expect(service3.listDoneProgressError, [0, 3, 0]);
      expect(client2.services[3].shortText, 'Покупка продуктов питания');
      expect(client2.services[3].listDoneProgressError, [0, 0, 0]);
    });
    test(
      'it add services and delete them in order: rejected->added->finished->outDated',
      () async {
        final httpClient = locator<AppData>().httpClient as mock.MockClient;
        expect(verifyNever(ExtMock(httpClient).testReqPostAdd).callCount, 0);
        // crete worker profile
        final wKey = wKeysData2();
        expect(wKey, isA<WorkerKey>());
        await locator<AppData>().addProfileFromKey(wKey);
        // add services
        final client = locator<AppData>().profiles.first.clients.first;
        final service3 = client.services[3];
        const servNum = 10;
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        //
        // > add 10 service
        //
        expect(service3.listDoneProgressError, [0, 10, 0]);
        expect(
          verify(ExtMock(httpClient).testReqPostAdd).callCount,
          (servNum + 1) * (servNum / 2),
        );
        when(ExtMock(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 1}', 200));
        await client.workerProfile.journal.commitAll();
        expect(service3.listDoneProgressError, [10, 0, 0]);
        expect(client.workerProfile.journal.finished.length, 10);
        //
        // > mark outdated
        //
        // service3.servicesInJournal.forEach((element) {
        //   element.provDate.add(const Duration(hours: -2));
        // });
        // client.workerProfile.services.clear();
        await service3.journal.workerProfile.syncHivePlanned();
        expect(client.workerProfile.journal.finished.length, 10);
        await client.workerProfile.journal.updateBasedOnNewPlanDate();
        expect(client.workerProfile.journal.outDated.length, 10);
        expect(service3.listDoneProgressError, [10, 0, 0]);
        //
        // > add 10 finished
        //
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(service3.listDoneProgressError, [20, 0, 0]);
        expect(verify(ExtMock(httpClient).testReqPostAdd).callCount, 20);
        //
        // > add 10 rejected
        //
        when(ExtMock(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('{"id": 0}', 200));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(service3.listDoneProgressError, [20, 0, 10]);
        expect(verify(ExtMock(httpClient).testReqPostAdd).callCount, 10);
        //
        // > add 10 stale
        //
        when(ExtMock(httpClient).testReqPostAdd)
            .thenAnswer((_) async => http.Response('', 500));
        for (var i = 0; i < servNum; i++) {
          await service3.add();
        }
        expect(service3.listDoneProgressError, [20, 10, 10]);
        expect(verify(ExtMock(httpClient).testReqGetPlanned).callCount, 2);
        expect(
          verify(ExtMock(httpClient).testReqPostAdd).callCount,
          (servNum + 1) * (servNum / 2),
        );
        //
        // > delete
        //
        when(ExtMock(httpClient).testReqDelete)
            .thenAnswer((_) async => http.Response('{"id": 0}', 200));
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.listDoneProgressError, [20, 10, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.listDoneProgressError, [20, 0, 0]);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.listDoneProgressError, [10, 0, 0]);
        expect(client.workerProfile.journal.outDated.length, 10);
        for (var i = 0; i < servNum; i++) {
          await service3.delete();
        }
        expect(service3.listDoneProgressError, [0, 0, 0]);
        expect(verify(ExtMock(httpClient).testReqDelete).callCount, 20);
      },
    );
  });
}
