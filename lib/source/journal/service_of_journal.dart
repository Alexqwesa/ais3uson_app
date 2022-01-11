
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'service_of_journal.g.dart';

/// ServiceOfJournal
///
/// ServiceOfJournal in state [ServiceState.added] the entry that will be send
/// to BD (and it will change state afterward).
///
/// {@category Journal}
@HiveType(typeId: 0)
class ServiceOfJournal with HiveObjectMixin {
  @HiveField(0)
  final int servId;
  @HiveField(1)
  final int contractId;
  @HiveField(2)
  final int workerId;
  @HiveField(3)
  //
  // > preinited vars
  //
  DateTime provDate = DateTime.now();
  @HiveField(4)
  ServiceState state = ServiceState.added;
  @HiveField(5)
  String error = '';
  @HiveField(6)
  String uid = uuid.v4();

  ServiceOfJournal({
    required this.servId,
    required this.contractId,
    required this.workerId,
  });
}
