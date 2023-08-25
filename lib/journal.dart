/// # This library contain [Journal] class itself.
///
/// It is used to manage issued services of worker:
///  - it store worker input as instance of [ServiceOfJournal],
///  - it send them to server,
///  - it archive old services,
///  - it send delete requests.
///
/// Each instance of [Worker] let access to [Journal] classes via providers:
///
/// - [Worker.journalOf],
/// - [Worker.journalAtDateOf],  // archived services at date
/// - [Worker.journalAllOf].     // all archived services
///
/// These providers point to a three classes [Journal], [JournalArchive] and [JournalArchiveAll].
///
/// The [JournalArchive] class is a cut version of [Journal], provide access to
/// services of previous days(one day specified by date).
///
/// The [JournalArchiveAll] class is a version of [JournalArchive], that
/// provides access to all days.
///
library journal;

import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/src/data_models_with_logic/worker.dart';

export 'package:ais3uson_app/src/api_classes/journal/service_of_journal.dart';
export 'package:ais3uson_app/src/api_classes/journal/service_state.dart';
export 'package:ais3uson_app/src/journal/journal.dart';
export 'package:ais3uson_app/src/journal/journal_archive.dart';
export 'package:ais3uson_app/src/journal/journal_archive_all.dart';
export 'package:ais3uson_app/src/journal/providers/days_with_services.dart';
export 'package:ais3uson_app/src/journal/providers/journal_archive_size.dart';
export 'package:ais3uson_app/src/journal/repositories/journal_hive_repository.dart';
export 'package:ais3uson_app/src/journal/repositories/journal_http_interface.dart';
