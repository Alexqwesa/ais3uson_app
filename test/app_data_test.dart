import 'dart:convert';
import 'dart:developer' as dev;

import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/journal_test_extensions.dart';
import 'helpers/setup_and_teardown_helpers.dart';
import 'helpers/worker_profile_test_extensions.dart';

void main() {
  //
  // > Setup
  //
  setUpAll(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    await init();
  });
  tearDownAll(() async {
    await tearDownTestHive();
  });
  setUp(() async {
    // SharedPreferences.setMockInitialValues({});
    locator.pushNewScope();
    await locator<SharedPreferences>().clear();
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
    test('it create Workers from SharedPreferences', () async {
      await locator<SharedPreferences>().setString(
        Departments.name,
        '[{"app":"AIS3USON web","name":"Работник Тестового Отделения №2","api_key":"3.01567984187","worker_dep_id":1,"dep":"Тестовое отделение https://alexqwesa.fvds.ru:48082","db":"kcson","servers":"https://alexqwesa.fvds.ru:48082","comment":"защищенный SSL","certBase64":""}]',
      );
      final ref = ProviderContainer();
      addTearDown(ref.dispose);
      //
      // > pre check locator
      //
      expect(
        // ignore: avoid_dynamic_calls
        (jsonDecode(
          locator<SharedPreferences>().getString(Departments.name) ?? '[]',
        ) as List<dynamic>)
            .first['app'],
        'AIS3USON web',
      );
      //
      // > crete ref
      //
      ref.listen(
        departmentsProvider,
        (previous, next) {
          return;
        },
        fireImmediately: true,
      );
      //
      // > check provider
      //
      expect(ref.read(departmentsProvider).length, 1);
      expect(
        ref.read(departmentsProvider).first.apiKey,
        '3.01567984187',
      );

      // await Hive.openBox<ServiceOfJournal>(ref.read(departmentsProvider).first.journal.journalHiveName);
      await ref.read(departmentsProvider).first.journal.postInit();
      ref.refresh(departmentsProvider);
      await ref.pump();

      expect(
          ref.read(ref.read(departmentsProvider).first.journal.servicesOf), []);
      // expect( ref.read(workerProfiles).first.ref.toString() ,"" );
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
        final wKey = testWorkerKey();
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
        // await locator<SharedPreferences>().setString(Departments.name, '[]');
        final ref = ProviderContainer();
        addTearDown(ref.dispose);
        // await init();
        //
        // > crete ref
        //

        expect(ref.read(departmentsProvider).length, 0);
        ref.listen(
          departmentsProvider,
          (previous, next) {
            return;
          },
          fireImmediately: true,
        );
        //
        // > check provider
        //
        expect(ref.read(departmentsProvider).length, 0);
        ref.read(departmentsProvider.notifier).addProfileFromKey(wKey);
        expect(
          ref.read(departmentsProvider).first.apiKey,
          '3.01567984187',
        );
        await ref
            .read(departmentsProvider)
            .first
            .journal
            .postInit(); // init journal

        //
        // > test that services are in archive
        //
        expect(ref
              .read(hiveRepositoryProvider(wKey.apiKey).notifier).init, true);
        // await ref.read(departmentsProvider).first.hiveRepository.future();
        expect(
            ref
                .read(departmentsProvider)
                .first
                .hiveRepository
                .openHive
                .requireValue
                .length,
            0);
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${ref.read(departmentsProvider).first.apiKey}',
        );
        expect(hiveArchive.length, 40);
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
        // await ref.pump();
        expect(
          ref.read(allDaysWithServicesProvider).length,
          2,
        );
        expect(
          ref
              .read(allDaysWithServicesProvider)
              .containsAll([roundYesterday, roundBeforeYesterday]),
          true,
        );
        await Future.wait(ref.read(departmentsProvider).map(
              (e) =>
                  ref.read(daysWithServicesProvider(e.apiKey).notifier).save(),
            ));
      },
    );
  });
}
