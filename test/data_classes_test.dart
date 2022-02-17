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
  group('Data Class', () {
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
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      final errorService =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      final wKey = WorkerKey.fromJson(
        jsonDecode(qrData2WithAutossl) as Map<String, dynamic>,
      );
      var hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(addedService);
      await hive.add(errorService);
      await errorService.setState(ServiceState.rejected);
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
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      final errorService =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      final wKey = wKeysData2();
      final hive =
          await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(addedService);
      await hive.add(errorService);
      await errorService.setState(ServiceState.rejected);
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
      expect(verify(ExtMock(httpClient).testReqPostAdd).callCount, 3);
      // wp.dispose();
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
    test('it archive yesterday services', () async {
      //
      // > prepare
      //
      final yesterdayService =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      final todayService =
          ServiceOfJournal(servId: 829, contractId: 1, workerId: 1);
      final wKey = wKeysData2();
      var hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      await hive.add(yesterdayService);
      await hive.add(todayService);
      final yesterday = DateTime.now().add(const Duration(days: -1));
      await yesterdayService.setState(ServiceState.finished);
      yesterdayService.provDate = yesterday;
      await yesterdayService.save();
      expect(yesterdayService.provDate, yesterday);
      expect(yesterdayService.state, ServiceState.finished);
      expect(yesterdayService.provDate, yesterday);
      //
      // > test hive
      //
      expect(hive.values.first.uid, yesterdayService.uid);
      expect(hive.values.last.state, ServiceState.added);
      await hive.flush();
      await hive.close();
      expect(hive.isOpen, false);
      hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      expect(hive.values.length, 2);
      expect(
        standardFormat.format(hive.values.first.provDate),
        standardFormat.format(yesterday),
      );
      //
      // > init AppData
      //
      await AppData.instance.addProfileFromKey(wKey);
      //
      // > test what yesterday services are in archive
      //
      expect(
        AppData.instance.profiles.first.journal.all.first.uid,
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
