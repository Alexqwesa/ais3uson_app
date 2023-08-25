import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journals_provider.g.dart';

/// Provider of [Journal] for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
@riverpod
class Journals extends _$Journals {
  late final JournalArchiveAll journalAllDates;
  late final JournalArchive journalAtDate;
  late final Journal journal;
  late final Worker worker;

  Journal get journalOf {
    return ref.watch(isArchiveProvider)
        ? (ref.watch(archiveDate) != null ? journalAtDate : journalAllDates)
        : state;
  }

  @override
  Journal build(String apiKey) {
    worker = ref.read(workerByApiProvider(apiKey));
    journalAllDates = JournalArchiveAll(worker);
    journalAtDate = JournalArchive(worker);
    journal = Journal(worker);

    return journal;
  }

  Journal get realJournalOf =>
      ref.read(journalsProvider(apiKey).notifier).journal;

  Journal get journalAllOf => journalAllDates;

  Journal journalAtDateOf(DateTime? date) {
    return date == DateTimeExtensions.today() || date == null
        ? journal
        : journalAtDate;
  }
}
