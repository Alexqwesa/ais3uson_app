import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';

import 'journal_test_extensions.dart';

extension WorkerTestExtensions on Worker {
  /// Only for tests! Don't use in real code.
  ///
  /// Async init actions such as:
  /// - postInit of [Journal] class,
  /// - read `clients`, `clientPlan` and `services` from repository.
  Future<void> postInit() async {
    await ref.read(journalOf).postInit();
    await ref.read(repositoryHttp(apiUrlClients).notifier).syncHiveHttp();
    await ref.read(repositoryHttp(apiUrlServices).notifier).syncHiveHttp();
    await ref.read(repositoryHttp(apiUrlPlan).notifier).syncHiveHttp();
  }

  /// List of assigned clients.
  List<ClientProfile> get clients => ref.read(clientsOf);

  /// For tests only.
  Journal get journal => ref.read(journalOf);

  /// List of services.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  List<ServiceEntry> get services => ref.read(servicesOf);

  /// All planned amount of each service for each client.
  List<ClientPlan> get clientsPlan => ref.read(clientsPlanOf);
}
