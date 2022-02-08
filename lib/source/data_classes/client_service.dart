import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/screens/service_related/proof_list.dart';
import 'package:flutter/material.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

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
  late final ServiceEntry service;
  late final ClientPlan planned;
  late final int workerDepId;

  /// Reference to existed journal
  late final Journal journal;

  String get apiKey => journal.apiKey;

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
  int get added => journal.added
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get done =>
      journal.finished
          .where((element) =>
              element.contractId == contractId && element.servId == service.id)
          .length +
      journal.outDated
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

  int get inJournal => journal.all
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get left => plan - filled - stalled - done - added;

  bool get addAllowed => left > 0;

  bool get deleteAllowed => inJournal > 0;

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

  /// [ProofList] of this service at current date.
  ProofList? _proofList;

  ClientService({
    required this.journal,
    required this.service,
    required this.planned,
    required this.workerDepId,
  }) {
    journal.addListener(notifyListeners);
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
        ServiceOfJournal(
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
}
