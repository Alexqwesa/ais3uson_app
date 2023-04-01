/// # journal classes
///
/// There are two classes [Journal] and [JournalArchive].
///
/// The [Journal] class store worker inputs as instances of [ServiceOfJournal],
/// it store them in 4 different lists (see [ServiceState]),
/// which are provided by [groupsOfJournal].
///
/// [Journal] class:
///
/// - store services in Hive(via provider [controllerOfJournal]),
/// - make network requests(add/delete),
/// - change state of [ServiceOfJournal],
/// - move old `finished` and `outDated` services into [JournalArchive].
///
/// The [JournalArchive] class is a cut version of [Journal],
/// it store old `finished` and `outDated services.
///
/// Each instance of [WorkerProfile] can access `Journal` classes via providers:
///
/// - [journalOfWorker],
/// - [journalOfWorkerAtDate].
///
/// [ClientProfile] can access both `Journal` classes at once via [journalOfClient].
///
library journal;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';

export 'package:ais3uson_app/src/journal/controller_dates_in_archive.dart';
export 'package:ais3uson_app/src/journal/controller_of_journal.dart';
export 'package:ais3uson_app/src/journal/journal.dart';
export 'package:ais3uson_app/src/journal/journal_archive.dart';
export 'package:ais3uson_app/src/journal/providers_of_journal.dart';
export 'package:ais3uson_app/src/journal/service_of_journal.dart';
export 'package:ais3uson_app/src/journal/service_state.dart';
