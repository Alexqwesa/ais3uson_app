import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/basic_providers.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_journal.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

/// This Journal, is the only one who can write to Hive.
final _journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  return Journal(wp);
});

/// Archived version of Journal at date, depend on archiveDate.
final _journalArchiveOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(archiveDate);

  return JournalArchive(wp);
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
