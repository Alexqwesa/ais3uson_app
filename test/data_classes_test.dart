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

import 'helpers/mock_server.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    await mySetUpAll();
  });
  tearDownAll(() async {
    await tearDownTestHive();
  });
  setUp(() async {
    //
    // > Hive setup
    //
    await setUpTestHive();
    try {
      // never fail adapter registration
      Hive
        ..registerAdapter(ServiceOfJournalAdapter())
        ..registerAdapter(ServiceStateAdapter());
    } on HiveError catch (e) {
      // print(e);
    }
    final hivData = await Hive.openBox<dynamic>('profiles');
    AppData().hiveData = hivData;
  });
  tearDown(() async {
    await AppData().asyncDispose();
    await tearDownTestHive();
  });
  group('Data Class', () {
    //
    // > test create WorkerProfile
    //
    test('Create WorkerProfile', () async {
      expect(
        WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2))),
        isA<WorkerProfile>(),
      );
    });
    //
    // > test json converters classes
    //
    test('Json converters classes', () async {
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      expect(wKey, isA<WorkerKey>());
      expect(wKey.apiKey, (jsonDecode(qrData2) as Map)['api_key']);
      expect(wKey.toJson(), jsonDecode(qrData2));
    });
    //
    // > test addition of services
    //
    test('Addition of service, with states: added, stale, rejected', () async {
      //
      // > prepare
      //
      final httpClient = AppData().httpClient;
      final wp = WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
      //
      // > configure addition successful
      //
      when(
        httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"id": 1}', 200));
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
      when(
        httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 400));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [1, 1, 0]);
      when(
        httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"id": 2}', 200));
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 0]);
      //
      // > configure addition rejected
      //
      when(
        httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"id": 0}', 200));
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 1]);
      expect(
        verify(httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        )).callCount,
        4,
      );
      // wp.dispose();
    });
    //
    // > test addition of services
    //
    test('Load serviceOfJournal from Hive and Journal', () async {
      //
      // > prepare
      //
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      var hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
      final service1 =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      await hive.add(service1);
      final errorService =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      await hive.add(errorService);
      await errorService.setState(ServiceState.rejected);
      //
      // > test hive
      //
      expect(hive.values.first.uid, service1.uid);
      expect(hive.values.last.state, ServiceState.rejected);
      // await hive.flush();
      // await hive.close();
      // hive = await Hive.openBox<ServiceOfJournal>('journal_${wkey.apiKey}');
      expect(hive.values.last.state,
          ServiceState.rejected); // This fail if uncomment code above
      expect(hive.values.first.state, ServiceState.added);
      expect(hive.values.last.uid, errorService.uid);
      //
      // > init WorkerProfile and mock http
      //
      final httpClient = AppData().httpClient;
      final wp = WorkerProfile(wKey);
      // delayed init, should look like values were loaded from hive
      when(
        httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"id": 1}', 200));
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
      expect(
        verify(httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        )).callCount,
        3,
      );
      // wp.dispose();
    });
  });
}
