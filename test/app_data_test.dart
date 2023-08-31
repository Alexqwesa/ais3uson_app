import 'dart:convert';
import 'dart:developer' as dev;

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/demo_worker_data.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_worker_keys_data.dart';

// import 'package:hive_test/hive_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions/journal_extension.dart';
import 'helpers/setup_and_teardown_helpers.dart';

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

    await Hive.openBox(hiveHttpCache);
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
        workerKeysInSharedPref,
        '[$demoWorkerKeyData]',
        // '[{"app":"AIS3USON web","name":"Работник Тестового Отделения №2","api_key":"3.01567984187","worker_dep_id":1,"dep":"Тестовое отделение https://alexqwesa.fvds.ru:48082","db":"kcson","servers":"https://alexqwesa.fvds.ru:48082","comment":"защищенный SSL","certBase64":""}]',
      );
      final ref = ProviderContainer();
      addTearDown(ref.dispose);
      //
      // > pre check locator
      //
      expect(
        // ignore: avoid_dynamic_calls
        (jsonDecode(
          locator<SharedPreferences>().getString(workerKeysInSharedPref) ??
              '[]',
        ) as List<dynamic>)
            .first['app'],
        'AIS3USON web',
      );
      //
      // > crete ref
      //
      ref.listen(
        workerKeysProvider,
        (previous, next) {
          return;
        },
        fireImmediately: true,
      );
      //
      // > check provider
      //
      expect(ref.read(workerKeysProvider).length, 1);
      expect(
        ref.read(workerKeysProvider).first.apiKey,
        '3.01567984187____',
      );

      // await Hive.openBox<ServiceOfJournal>(ref.read(workerKeysProvider).first.journal.journalHiveName);
      // await ref.read(workerKeysProvider).firstWorker.journal.postInit();
      // ref.refresh(workerKeysProvider);
      // await ref.pump();
      //
      // > it open hive box
      //
      await ref.read(hiveBox(hiveHttpCache).future);
      expect(ref.read(hiveBox(hiveHttpCache)).hasValue, true);
      expect(ref.read(workerKeysProvider).workers.first.clients.length, 0);
      expect(
          ref.read(
              ref.read(workerKeysProvider).firstWorker.journal.servicesOf),
          []);
      // expect( ref.read(workers).first.ref.toString() ,"" );
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
        final wKey = demoWorkerKey();
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
        // await locator<SharedPreferences>().setString(wokrerKeysInSharedPref, '[]');
        final ref = ProviderContainer();
        addTearDown(ref.dispose);
        // await init();
        //
        // > crete ref
        //

        expect(ref.read(workerKeysProvider).length, 0);
        ref.listen(
          workerKeysProvider,
          (previous, next) {
            return;
          },
          fireImmediately: true,
        );
        //
        // > check provider
        //
        expect(ref.read(workerKeysProvider).length, 0);
        await ref.read(workerKeysProvider).add(wKey);
        expect(
          ref.read(workerKeysProvider).first.apiKey,
          wKey.apiKey,
        );
        await ref
            .read(workerKeysProvider)
            .firstWorker
            .journal
            .postInit(); // init journal

        //
        // > test that services are in archive
        //
        expect(
            ref.read(hiveRepositoryProvider(wKey.apiKey).notifier).init, true);
        // await ref.read(workerKeysProvider).first.hiveRepository.future();
        expect(
            ref
                .read(workerProvider(wKey.apiKey).notifier)
                .journal
                .hiveRepository
                .openHive
                .requireValue
                .length,
            0);
        final hiveArchive = await Hive.openBox<ServiceOfJournal>(
          'journal_archive_${ref.read(workerKeysProvider).first.apiKey}',
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
        await Future.wait(ref.read(workerKeysProvider).map(
              (e) =>
                  ref.read(daysWithServicesProvider(e.apiKey).notifier).save(),
            ));
      },
    );
  });
}
