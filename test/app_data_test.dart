import 'dart:convert';
import 'dart:developer' as dev;

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/providers_dates_in_archive.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_models_test.dart';

void main() {
  //
  // > Setup
  //
  tearDownAll(() async {
    await tearDownTestHive();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    locator.pushNewScope();
    // Hive setup
    await setUpTestHive();
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
    await tearDownTestHive();
  });
  //
  // > Tests start
  //
  group('Tests for Providers', () {
    test('it create WorkerProfiles from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'WorkerKeys2':
            '[{"app":"AIS3USON web","name":"Работник Тестового Отделения №2","api_key":"3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c","worker_dep_id":1,"dep":"Тестовое отделение https://alexqwesa.fvds.ru:48082","db":"kcson","servers":"https://alexqwesa.fvds.ru:48082","comment":"защищенный SSL","certBase64":""}]',
      });
      await init();
      final ref = ProviderContainer();
      addTearDown(ref.dispose);
      //
      // > pre check locator
      //
      expect(
        // ignore: avoid_dynamic_calls
        (jsonDecode(
          locator<SharedPreferences>().getString('WorkerKeys2') ?? '[]',
        ) as List<dynamic>)
            .first['app'],
        'AIS3USON web',
      );
      //
      // > crete ref
      //
      ref.listen(
        workerProfiles,
        (previous, next) {
          return;
        },
        fireImmediately: true,
      );
      //
      // > check provider
      //
      expect(ref.read(workerProfiles).length, 1);
      expect(
        ref.read(workerProfiles).first.apiKey,
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
            autoServiceOfJournal(
              servId: 830,
              contractId: 1,
              workerId: 1,
              provDate: beforeYesterday,
              state: ServiceState.outDated,
            ),
          );
        }
        //
        // > ProviderContainer and init
        //
        final ref = ProviderContainer();
        addTearDown(ref.dispose);
        await init();
        //
        // > crete ref
        //
        ref.listen(
          workerProfiles,
          (previous, next) {
            return;
          },
          fireImmediately: true,
        );
        //
        // > check provider
        //
        expect(ref.read(workerProfiles).length, 0);
        ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
        expect(
          ref.read(workerProfiles).first.apiKey,
          '3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c',
        );
        await ref.read(workerProfiles).first.journal.postInit(); // init journal
        //
        // > test that services are in archive
        //
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${ref.read(workerProfiles).first.apiKey}',
        );
        expect(hiveArchive.length, 40);
        expect(ref.read(workerProfiles).first.journal.hive.values.length, 0);
        //
        // > test archive dates
        //
        final roundYesterday =
            DateTime(yesterday.year, yesterday.month, yesterday.day);
        final roundBeforeYesterday = DateTime(
          beforeYesterday.year,
          beforeYesterday.month,
          beforeYesterday.day,
        );
        // expect(ref.read(archiveDate), roundYesterday);
        expect(
          (await ref.read(datesInArchive.future))?.length,
          2,
        );
        expect(
          (await ref.read(datesInArchive.future))
              ?.toSet()
              .containsAll([roundYesterday, roundBeforeYesterday]),
          true,
        );
      },
    );
  });
}
