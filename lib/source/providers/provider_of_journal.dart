import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider of [Journal] for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
final journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  // () async {
  //   await ref.watch(hiveJournalBox(wp.hiveName).future);
  // }();

  return ref.watch(archiveDate) != null
      ? ref.watch(journalArchiveOfWorker(wp))
      : ref.watch(_journalOfWorker(wp));
});

// final fullArchiveOfWorker = Provider.family<Journal, WorkerProfile>(
// (ref, wp) {
//   return JournalArchive(wp, null);
// });

final fullArchiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  return [
    ...ref.read(archiveOfClient(client)),
    ...ref
        .read(_journalOfWorker(client.workerProfile))
        .all
        .where((element) => element.contractId == client.contractId),
  ];
});
final archiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  return JournalArchive(client.workerProfile, null)
      .all
      .where((element) => element.contractId == client.contractId)
      .toList();
});

/// Helper,
final _loadListServiceOfJournal =
    Provider.family<List<ServiceOfJournal>, String>((ref, hiveName) {
  // ignore: avoid_dynamic_calls

  return ref.watch(hiveJournalBox(hiveName)).value?.values.toList() ?? [];
});

/// This Journal can write to Hive
final _journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  return Journal(wp);
});

/// Depend on archiveDate, maybe autoDispose?
final journalArchiveOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  return JournalArchive(wp, ref.watch(archiveDate));
});
