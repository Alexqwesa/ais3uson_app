import 'dart:async';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

part 'client_service.freezed.dart';

/// Model for [ServiceCard] and [ClientService].
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

    /// Null - for dynamic date (from provider [archiveDate])
    DateTime? date,
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
  // > services getters
  //
  int get added =>
      ref.read(groupsOfService(this))?[ServiceState.added]?.length ?? 0;

  int get done =>
      (ref.read(groupsOfService(this))?[ServiceState.finished]?.length ?? 0) +
      (ref.read(groupsOfService(this))?[ServiceState.outDated]?.length ?? 0);

  // int get rejected =>
  //     ref.read(groupsOfService(this))?[ServiceState.rejected]?.length ?? 0;

  int get all => journal.all
      .where(
        (e) => e.contractId == contractId && e.servId == service.id,
      )
      .length;

  @Deprecated('Better use ref.watch of listDoneProgressErrorOfService')
  List<int> get listDoneProgressError =>
      ref.read(listDoneProgressErrorOfService(this));

  //
  // > logical getters
  //
  int get left => plan - filled - done - added;

  bool get addAllowed => left > 0;

  bool get deleteAllowed => all > 0;

  //
  // > proof managing
  //
  ProofList get proofList => ref.read(proofsAtDate(Tuple2(date, this)));

  void addProof() {
    proofList.addNewGroup();
  }

  /// Add [ServiceOfJournal].
  Future<void> add() async {
    if (addAllowed) {
      await journal.post(
        autoServiceOfJournal(
          servId: planned.servId,
          contractId: planned.contractId,
          workerId: workerDepId,
        ),
      );
    } else {
      showErrorNotification(locator<S>().serviceIsFull);
    }
  }

  /// Delete [ServiceOfJournal].
  Future<void> delete() async {
    await journal.delete(
      uuid: journal.getUuidOfLastService(
        servId: planned.servId,
        contractId: planned.contractId,
      ),
    );
  }
}
