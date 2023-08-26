import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/proofs.dart';
import 'package:ais3uson_app/src/data_models/client_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ClientServiceLogic on ClientService {
  Ref get ref => workerProfile.ref;

  // Provider<Journal> get journalOf => workerProfile.journalOf;

  // Journal get _journal => workerProfile.journalOf;

  //
  // > proof managing
  //
  Provider<(List<Proof>, ProofList)> get proofsOf => serviceProofAtDate(this);

  ProofList get proofs {
    final (_, controller) = ref.read(proofsOf);

    return controller;
  }

  void addProof() => proofs.addProof();

  ClientServiceState get state => ref.read(serviceStateProvider(this));

  Future<bool> delete()async => state.delete();

  Future<bool> add() async => state.add();

  bool get deleteAllowedOf => state.deleteAllowed;

  bool get addAllowedOf => state.addAllowed;

  List<int> get fullStateOf => state.fullState;
}
