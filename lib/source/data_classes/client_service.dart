import 'package:ais3uson_app/source/from_json/fio_planned.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/screens/service_related/proof_list.dart';
import 'package:flutter/material.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [FioPlanned]...
///
/// It only store [ProofList].
// ignore: prefer_mixin
class ClientService with ChangeNotifier {
  late final ServiceEntry service;
  late final FioPlanned planned;
  late final int workerDepId;

  /// Reference to existed journal
  late final Journal journal;

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

  String get image => service.image;

  //
  // > journal getters
  //
  int get done => journal.finished
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get stalled => journal.servicesForSync
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get rejected => journal.rejected
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get left => plan - filled - stalled - done;

  List<int> get listDoneProgressError => <int>[done, stalled, rejected];

  ProofList get proofList {
    if (_proofList != null) {
      return _proofList!;
    } else {
      _proofList = ProofList(
        workerDepId,
        contractId,
        standardFormat.format(DateTime.now()),
        servId,
      );
      unawaited(_proofList!.crawler());

      return _proofList!;
    }
  }

  ProofList? _proofList;

  ClientService({
    required this.journal,
    required this.service,
    required this.planned,
    required this.workerDepId,
  }) {
    journal.addListener(notifyListeners);
  }

  void addProof() {
    proofList.addNewGroup();
  }

  Future<void> add() async {
    journal.post(
      ServiceOfJournal(
        servId: planned.servId,
        contractId: planned.contractId,
        workerId: workerDepId,
      ),
    );
    notifyListeners();
  }

  Future<void> delete() async {
    await journal.deleteLast(
      servId: planned.servId,
      contractId: planned.contractId,
    );
    notifyListeners();
  }
}
