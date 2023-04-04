/// # This library contain [Journal] class itself.
///
/// It is used to manage issued services of worker:
///  - it store worker input as instance of [ServiceOfJournal],
///  - it send them to server,
///  - it archive old services,
///  - it send delete requests.
///
/// Each instance of [WorkerProfile] let access to [Journal] classes via providers:
///
/// - [WorkerProfile.journalOf],
/// - [WorkerProfile.journalAtDateOf],  // archived services at date
/// - [WorkerProfile.journalAllOf].     // all archived services
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

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';

export 'package:ais3uson_app/src/api_classes/inner/service_of_journal.dart';
export 'package:ais3uson_app/src/api_classes/inner/service_state.dart';
export 'package:ais3uson_app/src/journal/controller_dates_in_archive.dart';
export 'package:ais3uson_app/src/journal/journal.dart';
export 'package:ais3uson_app/src/journal/journal_archive.dart';
export 'package:ais3uson_app/src/journal/journal_archive_all.dart';
