import 'dart:async';

import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_classes/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:flutter/material.dart';

/// Model for [ServiceCard] and [ClientService].
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// {@category Data Classes}
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
  // > shortcuts for json classes
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

  //
  // > journal getters
  //
  Iterable<ServiceOfJournal> get servicesInJournal => journal.all.where(
        (element) =>
            element.contractId == contractId && element.servId == service.id,
      );

  int get added => journal.added
      .where(
        (element) =>
            element.contractId == contractId && element.servId == service.id,
      )
      .length;

  int get done =>
      journal.finished
          .where(
            (element) =>
                element.contractId == contractId &&
                element.servId == service.id,
          )
          .length +
      journal.outDated
          .where(
            (element) =>
                element.contractId == contractId &&
                element.servId == service.id,
          )
          .length;

  int get rejected => journal.rejected
      .where(
        (element) =>
            element.contractId == contractId && element.servId == service.id,
      )
      .length;

  int get inJournal => journal.all
      .where(
        (element) =>
            element.contractId == contractId && element.servId == service.id,
      )
      .length;

  int get left => plan - filled - done - added;

  bool get addAllowed => left > 0;

  bool get deleteAllowed => inJournal > 0;

  List<int> get listDoneProgressError => <int>[done, added, rejected];

  ProofList get proofList =>
      journal.workerProfile.ref.read(proofsOfServices(this));

  // {
  //   if (_proofList.inited) {
  //     return _proofList;
  //   } else {
  //     _proofList.crawler();
  //
  //     return _proofList;
  //   }
  // }

  // @override
  // void dispose() {
  //   journal.removeListener(notifyListeners);
  //
  //   return super.dispose();
  // }

  void addProof() {
    proofList.addNewGroup();
  }

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
      showErrorNotification('Данная услуга переполнена!');
    }
  }

  Future<void> delete() async {
    await journal.delete(
      uuid: journal.getUuidOfLastService(
        servId: planned.servId,
        contractId: planned.contractId,
      ),
    );
  }

  ClientService copyWith({
    Journal? newJournal,
    ServiceEntry? serv,
    ClientPlan? plan, // ProofList proofList
  }) {
    return ClientService(
      journal: newJournal ?? journal,
      planned: plan ?? planned,
      service: serv ?? service,
    );
  }
}
