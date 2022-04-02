// part of journal;
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'service_state.g.dart';

/// These states control [ServiceOfJournal].
///
/// ```
/// Usual life of [ServiceOfJournal] is:
///                 added -> finished -> outDated -> archived -> deleted
///                 added -> rejected ->                      -> deleted
///```
///
/// {@category Journal}
@HiveType(typeId: 10)
enum ServiceState {
  @HiveField(0)
  added,
  @HiveField(2)
  finished,
  @HiveField(3)
  rejected,
  @HiveField(4)
  outDated,
}
