import 'dart:async';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Model for [ServiceCard] and [ClientService].
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// {@category Data Models}
@immutable
class ClientService {
  const ClientService({
    required this.journal,
    required this.service,
    required this.planned,
  });

  /// Reference to existing [Journal].
  final Journal journal;

  /// Reference to existing [ServiceEntry].
  final ServiceEntry service;

  /// Reference to existing [ClientPlan].
  final ClientPlan planned;

  //
  // > shortcuts for underline classes
  //
  String get apiKey => journal.apiKey;

  int get workerDepId => journal.workerProfile.key.workerDepId;

  int get contractId => planned.contractId;

  int get servId => planned.servId;

  int get plan => planned.planned;

  int get filled => planned.filled;

  int get subServ => service.subServ;

  String get servText => service.servText;

  String get servTextAdd => service.servTextAdd;

  String get shortText => service.shortText;

  String get image => service.imagePath;

  ProviderContainer get ref => journal.ref;

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
  ProofList get proofList => ref.read(proofsOfServices(this));

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
      // notifyListeners();
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
