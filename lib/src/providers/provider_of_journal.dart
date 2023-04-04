import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

class ProviderOfJournal {
  const ProviderOfJournal(this.workerProfile);

  final WorkerProfile workerProfile;

  Provider<Journal> get realJournalOf => __journalOfWorker(workerProfile);

  Provider<Journal> get journalOf => _journalOfWorker(workerProfile);

  Provider<Journal> get journalAllOf =>
      _journalArchiveAllOfWorker(workerProfile);

  Provider<Journal> journalAtDateOf(DateTime date) =>
      _journalOfWorkerAtDate(Tuple2(workerProfile, date));
}

/// Provider of [Journal] for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
final _journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(isArchive);

  return ref.watch(archiveDate) != null
      ? ref.watch(_journalArchiveOfWorker(wp))
      : ref.watch(__journalOfWorker(wp));
});

/// Provider of [Journal] for [WorkerProfile] at specific date.
///
/// {@category Providers}
/// {@category Journal}
final _journalOfWorkerAtDate =
    Provider.family<Journal, Tuple2<WorkerProfile, DateTime?>>((ref, tuple) {
  final wp = tuple.item1;
  final date = tuple.item2;

  return date == DateTimeExtensions.today() || date == null
      ? ref.watch(__journalOfWorker(wp))
      : ref.watch(_journalArchiveOfWorker(wp));
});

/// This Journal, is the only one who can write new services to Hive.
final __journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  return Journal(wp);
});

/// Archived version of Journal at date, depend on archiveDate.
final _journalArchiveOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(archiveDate);

  return JournalArchive(wp);
});

/// Archived version of Journal with all dates, depend on archiveDate.
///
/// Exist just for caching results.
final _journalArchiveAllOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  return JournalArchiveAll(wp);
});
