import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
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

import 'fake_path_provider_platform.dart';
import 'journal_test_extensions.dart';
import 'real_hive_helpler.dart';

Future<(ProviderContainer, WorkerKey, Worker, mock.MockClient)>
    openRefContainer() async {
      await setUpRealHive();
  final openHttpBox = await Hive.openBox(hiveHttpCache);
  final wKey = wKeysData2();
  final ref = ProviderContainer(
    overrides: [
      hiveBox(hiveHttpCache).overrideWith((ref) => openHttpBox),
      httpClientProvider(wKey.certBase64)
          .overrideWithValue(getMockHttpClient()),
    ],
  );

  final httpClient =
      ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
  //
  // > start test
  //
  ref.read(departmentsProvider.notifier).addProfileFromKey(wKey);
  final wp = ref
      .read(departmentsProvider)
      .firstWhere((element) => element.apiKey == wKey.apiKey);

  return (ref, wKey, wp, httpClient);
}

extension WorkerTestExtensions on Worker {
  /// Only for tests! Don't use in real code.
  ///
  /// Async init actions such as:
  /// - postInit of [Journal] class,
  /// - read `clients`, `clientPlan` and `services` from repository.
  Future<void> postInit() async {
    await journalOf.postInit();
    // await (ref as ProviderContainer).pump();
    await ref.read(httpProvider(apiKey, urlClients).notifier).syncHiveHttp();
    await ref.read(httpProvider(apiKey, urlServices).notifier).syncHiveHttp();
    await ref.read(httpProvider(apiKey, urlPlan).notifier).syncHiveHttp();
  }

  /// List of assigned clients.
  List<ClientProfile> get clients => ref.watch(clientsOf);

  /// List of services.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  List<ServiceEntry> get services => ref.watch(servicesOf);

  /// All planned amount of each service for each client.
  List<ClientPlan> get clientsPlan => ref.watch(clientsPlanOf);
}
