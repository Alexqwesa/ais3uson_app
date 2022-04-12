import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/proof_list.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:flutter/material.dart';

/// Model for [ServiceCard] and [ClientService].
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// It only store [ProofList].
///
/// {@category Data_Classes}
// ignore: prefer_mixin
class ClientService with ChangeNotifier {
  ClientService({
    required this.journal,
    required this.client,
    required this.service,
    required this.planned,
  }) {
    _proofList = ProofList(
      workerDepId,
      contractId,
      standardFormat.format(DateTime.now()),
      servId,
      client: client.name,
      worker: journal.workerProfile.name,
      service: service.shortText,
    );
    journal.addListener(notifyListeners);
  }

  final ServiceEntry service;
  final ClientPlan planned;

  /// Reference to existed journal
  final Journal journal;
  final ClientProfile client;

  /// [ProofList] of this service at current date.
  late final ProofList _proofList;

  String get apiKey => journal.apiKey;

  int get workerDepId => journal.workerProfile.key.workerDepId;

  //
  // > from json classes
  //
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

  List<int> get doneStaleError => <int>[done, added, rejected];

  ProofList get proofList {
    if (_proofList.inited) {
      return _proofList;
    } else {
      _proofList.crawler();

      return _proofList;
    }
  }

  @override
  void dispose() {
    journal.removeListener(notifyListeners);

    return super.dispose();
  }

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
      notifyListeners();
    } else {
      showErrorNotification('Данная услуга переполнена!');
    }
  }

  Future<void> delete() async {
    final uuid = journal.getUuidOfLastService(
      servId: planned.servId,
      contractId: planned.contractId,
    );

    await journal.delete(uuid: uuid);
    notifyListeners();
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
      client: client,
    );
  }
}
