import 'dart:convert';

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
  group('Journal', () {
    test('it add services, with states: added, stale, rejected', () async {
      //
      // > prepare
      //
      final httpClient = AppData().httpClient as mock.MockClient;
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
      final httpClient =
          AppData().httpClient as mock.MockClient; // as MockHttpClientLibrary;
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
      await AppData.instance.addProfileFromKey(wKey);
      //
      // > test what yesterday services are in archive
      //
      expect(
        AppData.instance.profiles.first.journal.added.first.uid,
        todayService.uid,
      );
      final hiveArchive = await Hive.openBox<ServiceOfJournal>(
        'journal_archive_${AppData.instance.profiles.first.apiKey}',
      );
      expect(AppData.instance.profiles.first.journal.hive.values.length, 1);
      expect(hiveArchive.length, 1);
    });
  });
}
