
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'service_of_journal.g.dart';

/// ServiceOfJournal is a class to store one entry of [Journal] (one input service).
///
/// It is created in state [ServiceState.added], with current, date and unique uuid.
///
/// [Journal] send services in states [ServiceState.added] and [ServiceState.stalled]
/// to DB, and marked them [ServiceState.finished] or [ServiceState.rejected].
///
/// Services in state [ServiceState.finished] or  [ServiceState.outDated] send to
/// [Journal.hiveArchive] on next day.
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
  ServiceState _state = ServiceState.added;
  @HiveField(5)
  String error = '';
  @HiveField(6)
  String uid = uuid.v4();

  ServiceState get state => _state;

  set state(ServiceState value) {
    _state = value;
    save();
  }

  ServiceOfJournal({
    required this.servId,
    required this.contractId,
    required this.workerId,
  });

  ServiceOfJournal.copy({
    required this.servId,
    required this.contractId,
    required this.workerId,
    required this.provDate,
    required ServiceState state,
    required this.error,
    required this.uid,
  }) {
    _state = state;
  }
}
