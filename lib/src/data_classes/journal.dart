import 'package:flutter/material.dart';

/// ServiceState
///
/// usual life of [ServiceOfJournal] is:
///                 added   -> finished -> outDated -> [delete]
///                 stalled -> finished -> outDated -> [delete]
///                         -> rejected ->          -> [delete]
///
/// added and stalled | [synced to DB] | finished | [deleted on next day]
/// rejected | [deleted by user]
enum ServiceState { added, stalled, finished, rejected, outDated }

/// Journal
///
/// main repository for services(in various states), provided by worker
class Journal with ChangeNotifier {
  List<ServiceOfJournal> all = [];

  List<ServiceOfJournal>? get stalled =>
      all.where((element) => element.state == ServiceState.stalled).toList();

  List<ServiceOfJournal>? get affect => all
      .where((element) => [
            ServiceState.stalled,
            ServiceState.added,
            ServiceState.finished,
          ].contains(element.state))
      .toList();

  Future<void> deleteOldServices() async {}
}

/// ServiceOfJournal
///
/// ServiceOfJournal in state [ServiceState.added] the entry that will be send
/// to BD (and it will change state afterward).
class ServiceOfJournal {
  final int servId;
  final int contractId;
  final int workerId;
  final int depId;
  final DateTime provDate = DateTime.now();
  ServiceState state = ServiceState.added;

  ServiceOfJournal(this.servId, this.contractId, this.workerId, this.depId);
}
