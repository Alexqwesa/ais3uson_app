/// # This library contain [Journal] and related classes.
///
/// It manages services issued by workers:
///  - it store worker input as instance of [ServiceOfJournal],
///  - it send them to server,
///  - it archive old services,
///  - it send delete requests.
///
/// Provider [journalProvider] return [Journal] or one of it's subclasses:
///
/// The [JournalArchive] class is a cut version of [Journal], that provide access to
/// services at date == [appStateIsProvider].atDate.
///
/// The [JournalArchiveAll] class is a version of [JournalArchive], that
/// provides access to all days.
///
library journal;

import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';

export 'package:ais3uson_app/src/api_classes/journal/service_of_journal.dart';
export 'package:ais3uson_app/src/api_classes/journal/service_state.dart';
export 'package:ais3uson_app/src/journal/journal.dart';
export 'package:ais3uson_app/src/journal/journal_archive.dart';
export 'package:ais3uson_app/src/journal/journal_archive_all.dart';
export 'package:ais3uson_app/src/journal/providers/days_with_services.dart';
export 'package:ais3uson_app/src/journal/providers/journal_archive_size.dart';
export 'package:ais3uson_app/src/journal/providers/journal_provider.dart';
export 'package:ais3uson_app/src/journal/repositories/journal_hive_repository.dart';
export 'package:ais3uson_app/src/journal/repositories/journal_http_interface.dart';
