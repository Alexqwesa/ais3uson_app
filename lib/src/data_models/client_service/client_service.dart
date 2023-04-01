import 'dart:async';

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/helpers/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/ui_service_card_widget.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

part 'client_service.freezed.dart';

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// {@category Data Models}
@freezed
class ClientService with _$ClientService {
  const factory ClientService({
    /// Reference to existing [WorkerProfile].
    required WorkerProfile workerProfile,

    /// Reference to existing [ServiceEntry].
    required ServiceEntry service,

    /// Reference to existing [ClientPlan].
    required ClientPlan planned,

    /// Should be Null to depend on global variable, !null break dependency.
    @Default(null) DateTime? date,
  }) = _ClientService;

  const ClientService._();

  //
  // > shortcuts for underline classes
  //
  String get apiKey => workerProfile.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

  int get contractId => planned.contractId;

  int get servId => planned.servId;

  int get plan => planned.planned;

  int get filled => planned.filled;

  int get subServ => service.subServ;

  String get servText => service.servText;

  String get servTextAdd => service.servTextAdd;

  String get shortText => service.shortText;

  String get image => service.imagePath;

  ProviderContainer get ref => workerProfile.ref;

  Journal get journal => ref.read(journalOfWorker(workerProfile));

  //
  // > proof managing
  //
  Proofs get proofList => ref.read(servProofAtDate(Tuple2(date, this)));

  void addProof() {
    proofList.addNewGroup();
  }

  /// Add [ServiceOfJournal].
  Future<void> add() async {
    if (ref.read(addAllowedOfService(this))) {
      await journal.post(
        autoServiceOfJournal(
          servId: planned.servId,
          contractId: planned.contractId,
          workerId: workerDepId,
        ),
      );
    } else {
      showErrorNotification(tr().serviceIsFull);
    }
  }

  /// Delete [ServiceOfJournal].
  Future<void> delete() async {
    if (ref.read(deleteAllowedOfService(this))) {
      await journal.delete(
        uuid: journal.getUuidOfLastService(
          servId: planned.servId,
          contractId: planned.contractId,
        ),
      );
    }
  }
}
