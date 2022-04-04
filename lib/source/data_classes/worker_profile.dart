// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/providers/worker_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A profile of worker.
///
/// {@category Data_Classes}
// ignore: prefer_mixin
class WorkerProfile with ChangeNotifier {
  /// Constructor [WorkerProfile] with [Journal] by default
  /// or with [JournalArchive].
  ///
  /// TODO: finish detect SSL code
  WorkerProfile(this.key, this.ref, {DateTime? archiveDate}) {
    name = key.name;
    journal =
        archiveDate != null ? JournalArchive(this, archiveDate) : Journal(this);
    fullArchive = JournalArchive(this, null);
    // var httpClient = ref.read(httpClientProvider);
  }

  final WorkerKey key;
  late final Journal journal;
  late final JournalArchive fullArchive;
  late final String name;

  final ProviderContainer ref;

  String get apiKey => key.apiKey;

  List<ClientPlan> get clientPlan => _clientPlan;

  List<ClientProfile> get clients => _clients;

  List<ServiceEntry> get services => _services;

  /// Service list should only update on empty, or unknown planned service.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  /// TODO: update by server policy.
  List<ServiceEntry> _services = [];

  /// Planned amount of services for client.
  ///
  /// Since we get data in bunch - store it in [WorkerProfile].
  List<ClientPlan> _clientPlan = [];

  /// list of clients List<ClientProfile>
  List<ClientProfile> _clients = [];

  @override
  void dispose() {
    journal.dispose();

    return super.dispose();
  }

  WorkerProfile copyWith({DateTime? archiveDate}) {
    return WorkerProfile(key, ref, archiveDate: archiveDate);
  }

  /// Async init actions such as:
  ///
  /// - postInit [journal] (instance of [Journal] class),
  /// - read [clients], [clientPlan] and [services] from hive if empty,
  /// - check last sync dates and sync [clients], [clientPlan] and [services],
  /// - and call notifyListeners.
  Future<void> postInit() async {
    await journal.postInit();

    _services = ref.read(servicesOfWorker(this));

    _clients = ref.read(clientsOfWorker(this));

    _clientPlan = ref.read(planOfWorker(this));

    notifyListeners();
  }

  /// Make sure all [ClientService]s of [ClientProfile] is initialized.
  Future<void> ensureClientInitialized() async {
    await Future.wait(
      clients.map(
        (element) {
          return element.updateServices();
        },
      ),
    );
  }

  Future<void> syncHiveClients() async {
    final url = '${key.activeServer}/client';
    await ref.read(httpDataProvider([apiKey, url]).notifier).update();
  }

  Future<void> syncHivePlanned() async {
    final url = '${key.activeServer}/planned';
    await ref.read(httpDataProvider([apiKey, url]).notifier).update();
  }

  /// Synchronize services for [WorkerProfile._services].
  ///
  /// Services usually updated once per year, and before calling this function
  /// we should check: is it really necessary, i.e. is [_services] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [_clientPlan] with wrong [ClientPlan.servId].
  Future<void> syncHiveServices() async {
    final url = '${key.activeServer}/services';
    await ref.read(httpDataProvider([apiKey, url]).notifier).update();
  }

  /// This should only be called if there is inconsistency:
  ///
  /// [ClientPlan] had nonexist service Id. This can happen:
  /// - then list of [ServiceEntry] is reduced on server,
  /// - database has inconsistency. TODO: check it here - low priority.
  Future<void> checkAllServicesExist() async {
    if (_services.isEmpty) {
      await syncHiveServices();
    } else if (ref
        .read(servicesOfWorkerSyncDate(this))
        .isBefore(ref.read(planOfWorkerSyncDate(this)))) {
      await syncHiveServices();
    } else {
      // TODO: actual checks here
    }
  }
}
