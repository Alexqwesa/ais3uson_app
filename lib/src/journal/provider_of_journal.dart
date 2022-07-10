import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Provider of [Journal] for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
final journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(isArchive);

  return ref.watch(archiveDate) != null
      ? ref.watch(_journalArchiveOfWorker(wp))
      : ref.watch(_journalOfWorker(wp));
});

/// Provider of [Journal] for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
final journalOfWorkerAtDate =
    Provider.family<Journal, Tuple2<WorkerProfile, DateTime?>>((ref, tuple) {
  final wp = tuple.item1;
  final date = tuple.item2;

  return date == DateTimeExtensions.today() || date == null
      ? ref.watch(_journalOfWorker(wp))
      : ref.watch(_journalArchiveOfWorker(wp));
});

/// Today + archived [ServiceOfJournal] of client.
///
/// {@category Providers}
final journalOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  ref.watch(groupsOfJournal(ref.watch(_journalOfWorker(client.workerProfile))));

  return [
    ...ref.watch(_archiveOfClient(client)),
    ...ref
        .watch(_journalOfWorker(client.workerProfile))
        .all
        .where((element) => element.contractId == client.contractId),
  ];
});

/// This Journal, is the only one who can write new services to Hive.
final _journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  return Journal(wp);
});

/// Archived version of Journal at date, depend on archiveDate.
final _journalArchiveOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(archiveDate);

  return JournalArchive(wp);
});

/// Helper for provider [journalOfClient],
final _archiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  ref.watch(hiveJournalBox(client.workerProfile.hiveName));

  return (ref.watch(
            servicesOfJournal(
              ref.watch(_journalArchiveAllOfWorker(client.workerProfile)),
            ),
          ) ??
          [])
      .where((element) => element.contractId == client.contractId)
      .toList();
});

/// Archived version of Journal with all dates, depend on archiveDate.
///
/// Helper for provider [_archiveOfClient],
/// which is helper for [journalOfClient].
/// Exist just for caching results.
final _journalArchiveAllOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  return JournalArchiveAll(wp);
});
