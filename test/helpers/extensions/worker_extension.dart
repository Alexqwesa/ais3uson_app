// ignore_for_file: await_only_futures

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show getMockHttpClient;
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart'
    as mock;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../fake_path_provider_platform.dart';
import '../setup_and_teardown_helpers.dart';
import 'journal_extension.dart';

Future<(ProviderContainer, WorkerKey, Worker, mock.MockClient)>
    openRefContainer() async {
  // await setUpRealHive();
  await setUpTestHive();
  final wKey = wKeysData2();
  // final apiKey = wKey.apiKey;

  final httpBox = await Hive.openBox(hiveHttpCache);
  // final journalBox = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
  // final archiveBox = await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');

  final ref = ProviderContainer(
    overrides: [
      // hiveJournalBox('journal_$apiKey').overrideWith((ref) => journalBox),
      // hiveJournalBox('journal_archive_$apiKey').overrideWith((ref) => archiveBox),
      hiveBox(hiveHttpCache).overrideWith((ref) => httpBox),
      httpClientProvider(wKey.certBase64)
          .overrideWithValue(getMockHttpClient()),
    ],
  );
  expect(ref.read(hiveBox(hiveHttpCache)).isLoading, false);
  // await ref.read(hiveJournalBox('journal_$apiKey').future);
  // expect(ref.read(hiveJournalBox('journal_$apiKey')).isLoading, false);
  // await ref.read(hiveJournalBox('journal_archive_$apiKey').future);
  // expect(ref.read(hiveJournalBox('journal_archive_$apiKey')).isLoading, false);
  // await ref.pump();

  final httpClient =
      ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
  //
  // > start test
  //
  await ref.read(workerKeysProvider).add(wKey);
  // await ref.pump();
  final wp = ref.read(workerProvider(wKey.apiKey).notifier);

  return (ref, wKey, wp, httpClient);
}

extension WorkerTestExtensions on Worker {
  /// Only for tests! Don't use in real code.
  ///
  /// Async init actions such as:
  /// - postInit of [Journal] class,
  /// - read `clients`, `clientPlan` and `services` from repository.
  Future<void> postInit() async {
    await this.journal.postInit();
    // await (ref as ProviderContainer).pump();
    //      ref.watch(httpProvider(apiKey, urlClients).notifier);
    //  ref.watch(httpProvider(apiKey, urlServices).notifier);
    //  ref.watch(httpProvider(apiKey, urlPlan).notifier);

    // why await is needed here?
    await ref
        .watch(httpProvider(apiKey, Worker.urlClients).notifier)
        .updateIfOld();
    await ref
        .watch(httpProvider(apiKey, Worker.urlServices).notifier)
        .updateIfOld();
    await ref
        .watch(httpProvider(apiKey, Worker.urlPlan).notifier)
        .updateIfOld();
  }

  /// List of assigned clients.
  // List<Client> get clients => state.clients;

  /// List of services.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  List<ServiceEntry> get services => state.services;

  /// All planned amount of each service for each client.
  List<ClientPlan> get clientsPlan => state.planned;
}
