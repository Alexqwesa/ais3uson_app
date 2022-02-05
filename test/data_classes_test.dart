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

import 'helpers/mock_server.dart'
    show ExtMock, getMockHttpClient;
import 'helpers/mock_server.mocks.dart' as mock;

void main() {
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
  group('Data Class', () {
    test('it create WorkerProfile', () async {
      expect(
        WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2))),
        isA<WorkerProfile>(),
      );
    });
    test('it convert json to WorkerKey', () async {
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      expect(wKey, isA<WorkerKey>());
      expect(wKey.apiKey, (jsonDecode(qrData2) as Map)['api_key']);
      expect(wKey.toJson(), jsonDecode(qrData2));
    });
    test('it add services, with states: added, stale, rejected', () async {
      //
      // > prepare
      //
      final httpClient = AppData().httpClient as mock.MockClient;
      final wp = WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
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
    test(
      'it load serviceOfJournal from Hive and add new one to journal',
      () async {
        //
        // > prepare
        //
        final addedService =
            ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
        final errorService =
            ServiceOfJournal(servId: 828, contractId: 1, workerId: 1);
        final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
        final hive =
            await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
        await hive.add(addedService);
        await hive.add(errorService);
        await errorService.setState(ServiceState.rejected);
        //
        // > test hive
        //
        expect(hive.values.first.uid, addedService.uid);
        expect(hive.values.last.state, ServiceState.rejected);
        // await hive.flush();
        // await hive.close();
        // hive = await Hive.openBox<ServiceOfJournal>('journal_${wKey.apiKey}');
        expect(
          // TODO: fix: This fail if uncomment code above
          hive.values.last.state,
          ServiceState.rejected,
        );
        expect(hive.values.first.state, ServiceState.added);
        expect(hive.values.last.uid, errorService.uid);
        //
        // > init WorkerProfile and mock http
        //
        final httpClient = AppData().httpClient
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
      },
    );
    test('it check date of last sync before sync on load', () async {
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      expect(wKey, isA<WorkerKey>());

      final httpClient = AppData().httpClient as mock.MockClient;
      await AppData.instance.addProfileFromKey(wKey);

      expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 0);
    });
  });
}
