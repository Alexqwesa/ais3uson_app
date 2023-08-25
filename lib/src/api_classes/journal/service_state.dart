// part of journal;
import 'package:ais3uson_app/journal.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'service_state.g.dart';

/// These states are used to describe [ServiceOfJournal].
///
/// Usual life of [ServiceOfJournal] and it's states, looks like:
///
/// | Created | Sent to DB | This day |Next day                | Deleted              |
/// |---------|------------|----------|---------------         |----------------------|
/// | `added` | `finished` |          |`outDated` and archived | when archive is full |
/// | `added` | `rejected` |          |never archived          | deleted by user      |
/// | `added` | `finished` | `removed` by user request|        | deleted by user      |
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
  @HiveField(5)
  removed,
}
