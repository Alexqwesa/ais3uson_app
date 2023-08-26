import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/proofs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_service_state.freezed.dart';

///
///
/// {@category Data Models}
// @freezed
@freezed
class ClientServiceState with _$ClientServiceState {
  const factory ClientServiceState({
    required int rejected,
    required int added,

    /// plan - filled
    required int left,

    /// finished + outDated
    required int done,
    required ClientService client,
    required Ref ref,

    /// Only true for Archive app state
    @Default(false) bool isReadOnly,
  }) = _ClientServiceState;

  const ClientServiceState._();

  bool get deleteAllowed => !isReadOnly && done + added + rejected > 0;

  bool get addAllowed => !isReadOnly && done + added + rejected < left;

  List<int> get fullState => [done, added, rejected];

  /// Add [ServiceOfJournal].
  Future<bool> add() async {
    // ClientServiceState(left: null);

    if (addAllowed) {
      final journal = ref.watch(journalProvider(client.apiKey));
      return journal.post(
        autoServiceOfJournal(
          servId: client.servId,
          contractId: client.contractId,
          workerId: client.workerDepId,
        ),
      );
    } else {
      showErrorNotification(tr().serviceIsFull);
      return false;
    }
  }

  /// Delete [ServiceOfJournal].
  Future<bool> delete() async {
    if (deleteAllowed) {
      final journal = ref.watch(journalProvider(client.apiKey));
      return journal.delete(
        uuid: journal.getUuidOfLastService(
          servId: client.servId,
          contractId: client.contractId,
        ),
      );
    }
    return false;
  }

// Journal get _journal => workerProfile.journalOf;

//
// > proof managing
//
  Provider<(List<Proof>, ProofList)> get proofsOf => serviceProofAtDate(client);

  ProofList get proofs {
    final (_, controller) = ref.watch(proofsOf);

    return controller;
  }

  void addProof() => proofs.addProof();
}
