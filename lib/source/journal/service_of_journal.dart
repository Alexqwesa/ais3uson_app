import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'service_of_journal.freezed.dart';

part 'service_of_journal.g.dart';

/// ServiceOfJournal is a class to store one entry of [Journal] (one input service).
///
/// It is created in state [ServiceState.added], with current, date and unique uuid.
///
/// [Journal] send services in state [ServiceState.added]
/// to DB, and marked(recreate) them [ServiceState.finished] or [ServiceState.rejected].
///
/// Services in state [ServiceState.finished] or  [ServiceState.outDated] send to
/// [Journal.hiveArchive] on next day.
///
/// {@category Journal}
@freezed
class ServiceOfJournal extends HiveObject with _$ServiceOfJournal {
  @HiveType(typeId: 0) // , adapterName: 'ServiceOfJournalAdapter')
  factory ServiceOfJournal({
    @HiveField(0) required int servId,
    @HiveField(1) required int contractId,
    @HiveField(2) required int workerId,
    @HiveField(3) required DateTime provDate,
    @HiveField(4) required String uid,
    @HiveField(5) @Default(ServiceState.added) ServiceState state,
    @HiveField(6) @Default('') String error,
  }) = _ServiceOfJournal;

  ServiceOfJournal._();

  factory ServiceOfJournal.fromJson(Map<String, dynamic> json) =>
      _$$_ServiceOfJournalFromJson(json);
}

/// Helper for ServiceOfJournal - call const constructor with dynamic default values.
/// - uid: uuid.v4(),
/// - provDate: provDate ?? DateTime.now().
// ignore: long-parameter-list
ServiceOfJournal autoServiceOfJournal({
  required int servId,
  required int contractId,
  required int workerId,
  DateTime? provDate,
  ServiceState? state,
}) {
  return ServiceOfJournal(
    servId: servId,
    contractId: contractId,
    workerId: workerId,
    uid: uuid.v4(),
    provDate: provDate ?? DateTime.now(),
    state: state ?? ServiceState.added,
  );
}
