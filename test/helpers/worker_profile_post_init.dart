import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/repositories.dart';

extension WorkerProfilePostInit on WorkerProfile {
  /// Only for tests! Don't use in real code.
  ///
  /// Async init actions such as:
  /// - postInit of [Journal] class,
  /// - read `clients`, [clientPlan] and [services] from repository.
  Future<void> postInit() async {
    await ref.read(journalOfWorker(this)).postInit();
    await ref.read(repositoryHttp(apiUrlClients).notifier).syncHiveHttp();
    await ref.read(repositoryHttp(apiUrlServices).notifier).syncHiveHttp();
    await ref.read(repositoryHttp(apiUrlPlan).notifier).syncHiveHttp();
  }
}
