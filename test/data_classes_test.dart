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
    test('Addition of service', () async {
      //
      // > prepare
      //
      final httpClient = AppData().httpClient;
      final wp = WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
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
      // final body = '{"vdate":"2022-01-31","uuid":"${wp.journal.all.first.uid}",'
      //     '"contracts_id":1,"dep_has_worker_id":1,"serv_id":828}';
      //
      // > repeat test with [commitAll]
      //
      await wp.clients[0].services[0].add();
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 0, 0]);
      expect(
        verify(httpClient.post(
          Uri.parse('http://80.87.196.11:48080/add'),
          headers: httpTestHeader,
          body: anyNamed('body'),
        )).callCount,
        2,
      );
      wp.dispose();
    });
    //
    // > test addition of services
    //
    test('Load serviceOfJournal from Hive', () async {
      //
      // > prepare
      //
      final httpClient = AppData().httpClient;
      final wp = WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
      final hive = await Hive.openBox<ServiceOfJournal>('journal_${wp.apiKey}');
      await hive.add(
        ServiceOfJournal(servId: 828, contractId: 1, workerId: 1),
      );
      final errorService =
          ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
      await hive.add(errorService);
      await errorService.setState(ServiceState.rejected);
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
      // > start test
      //
      expect(wp.clients[0].services[0].listDoneProgressError, [0, 1, 1]);
      expect(wp.clients[0].services[0].deleteAllowed, true);
      await wp.clients[0].services[0].delete();
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [1, 1, 0]);
      await wp.clients[0].services[0].add();
      expect(wp.clients[0].services[0].listDoneProgressError, [2, 1, 0]);
      await wp.journal.commitAll();
      expect(wp.clients[0].services[0].listDoneProgressError, [3, 0, 0]);
      wp.dispose();
    });
  });
}
