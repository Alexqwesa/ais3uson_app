import 'dart:convert';
import 'dart:developer' as dev;

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'helpers/mock_server.dart' show getMockHttpClient;

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
    // httpClient setup
    AppData().httpClient = getMockHttpClient();
    // always register hive adapters
    try {
      // never fail on double adapter registration
      Hive
        ..registerAdapter(ServiceOfJournalAdapter())
        ..registerAdapter(ServiceStateAdapter());
      // ignore: avoid_catching_errors
    } on HiveError catch (e) {
      dev.log(e.toString());
    }
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
  group('AppData Class', () {
    test('it create WorkerProfiles from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'WorkerKeys':
            '[{"app":"AIS3USON web","name":"Работник Тестового Отделения №2","api_key":"3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c","worker_dep_id":1,"dep":"Тестовое отделение https://alexqwesa.fvds.ru:48082","db":"kcson","host":"alexqwesa.fvds.ru","port":"48082","comment":"защищенный SSL","ssl":"auto","certBase64":""}]',
      });
      await AppData.instance.postInit();
      expect(AppData.instance.profiles.length, 1);
      expect(
        AppData.instance.profiles.first.apiKey,
        '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c',
      );
    });
    test(
      'it collect list of dates from archived services',
      () async {
        //
        // > prepare
        //
        final yesterday = DateTime.now().add(const Duration(days: -1));
        final beforeYesterday = yesterday.add(const Duration(days: -1));
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
          await hive.add(autoServiceOfJournal(
            servId: 830,
            contractId: 1,
            workerId: 1,
            provDate: beforeYesterday,
            state: ServiceState.outDated,
          ));
        }
        //
        // > AppData init
        //
        await AppData.instance.postInit();
        await AppData.instance.addProfileFromKey(wKey);
        // await AppData.instance
        //
        // > test that services are in archive
        //
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${AppData.instance.profiles.first.apiKey}',
        );
        expect(AppData.instance.profiles.first.journal.hive.values.length, 0);
        expect(hiveArchive.length, 40);
        //
        // > test archive dates
        //
        final roundYesterday =
            DateTime(yesterday.year, yesterday.month, yesterday.day);
        final roundBeforYesterday = DateTime(
          beforeYesterday.year,
          beforeYesterday.month,
          beforeYesterday.day,
        );
        expect(AppData.instance.archiveDate, roundYesterday);
        expect(AppData.instance.datesInArchive.length, 2);
        expect(
          AppData.instance.datesInArchive
              .containsAll([roundYesterday, roundBeforYesterday]),
          true,
        );
      },
    );
  });
}
