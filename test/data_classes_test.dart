import 'dart:convert';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
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
    test('create WorkerProfile', () async {
      expect(
        WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2))),
        isA<WorkerProfile>(),
      );
    });
    //
    // > test json converters classes
    //
    test('json converters classes', () async {
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      expect(wKey, isA<WorkerKey>());
      expect(wKey.apiKey, (jsonDecode(qrData2) as Map)['api_key']);
      expect(wKey.toJson(), jsonDecode(qrData2));
    });
    //
    // > test addition of services
    //
    test('test addition of service', () async {
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
  });
}
