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
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'default_data.dart';
import 'mock_server.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  final appData = AppData();
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await setUpTestHive();
    Hive
      ..registerAdapter(ServiceOfJournalAdapter())
      ..registerAdapter(ServiceStateAdapter());
    final hivData = await Hive.openBox<dynamic>('profiles');
    AppData().hiveData = hivData;
  });
  group('Worker Profile', () {
    test('create WorkerProfile and test it with mock server', () async {
      final client = MockClient();
      AppData().httpClient = client;

      // when(mockSharedPreferences.setString(any, any))
      //     .thenAnswer((_) async => true);
      // await AppData().postInit();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(
        Uri.parse('http://80.87.196.11:48080/clients'),
      )).thenAnswer((_) async => http.Response(SERVER_DATA_CLIENTS, 200));
      when(client.get(Uri.parse('http://80.87.196.11:48080/services')))
          .thenAnswer((_) async => http.Response(SERVER_DATA_SERVICES, 200));
      when(client.get(Uri.parse('http://80.87.196.11:48080/planned')))
          .thenAnswer((_) async => http.Response(SERVER_DATA_PLANNED, 200));
      when(client.get(Uri.parse('http://80.87.196.11:48080/stat')))
          .thenAnswer((_) async => http.Response(SERVER_DATA_CLIENTS, 200));

      expect(
        await () async {
          return WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
        }(),
        isA<WorkerProfile>(),
      );
    });
  });
  // tearDown(() async {
  //   await tearDownTestHive();
  // });
}
