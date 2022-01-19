
// part of journal;
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:hive_flutter/hive_flutter.dart';


part 'service_state.g.dart';
/// These states control [ServiceOfJournal].
///
/// ```
/// Usual life of [ServiceOfJournal] is:
///                 added   -> finished -> outDated -> deleted
///                 stalled -> finished -> outDated -> deleted
///                 [both]  -> rejected ->          -> deleted
///```
/// added and stalled | [Journal.commitAdd]ed to DB | finished | [Journal.archiveOldServices] on next day
/// rejected | [Journal.delete]d by user.
///
/// {@category Journal}
@HiveType(typeId: 10)
enum ServiceState {
  @HiveField(0)
  added,
  @HiveField(1)
  stalled,
  @HiveField(2)
  finished,
  @HiveField(3)
  rejected,
  @HiveField(4)
  outDated,
}
