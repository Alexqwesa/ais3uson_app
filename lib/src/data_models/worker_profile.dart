import 'dart:async';
import 'dart:convert';

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_entities.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// A profile of worker, just model with shortcuts to various providers.
///
/// {@category Data Models}
@immutable
class WorkerProfile {
  /// Constructor [WorkerProfile] with [Journal] by default
  const WorkerProfile(this.apiKey, this.ref);

  final String apiKey;

  final ProviderContainer ref;

  String get name => key.name;

  String get hiveName => 'journal_$apiKey';

  String get urlClients => '${key.activeServer}/clients';

  String get urlPlan => '${key.activeServer}/planned';

  String get urlServices => '${key.activeServer}/services';

  Tuple2<WorkerKey, String> get apiUrlClients => Tuple2(key, urlClients);

  Tuple2<WorkerKey, String> get apiUrlPlan => Tuple2(key, urlPlan);

  Tuple2<WorkerKey, String> get apiUrlServices => Tuple2(key, urlServices);

  WorkerKey get key {
    try {
      return ref.read(workerProfiles.notifier).key(apiKey);
    }
    // ignore: avoid_catching_errors
    on StateError {
      return WorkerKey.fromJson(
        jsonDecode(stubJsonWorkerKey) as Map<String, dynamic>,
      );
    }
  }

  /// For tests only.
  Journal get journal => ref.read(journalOfWorker(this));

  /// List of assigned clients.
  List<ClientProfile> get clients => ref.read(clientsOfWorker(this));

  /// All planned amount of each service for each client.
  List<ClientPlan> get clientPlan => ref.read(planOfWorker(this));

  DateTime get planSyncDate => ref.read(planOfWorkerSyncDate(this));

  DateTime get servicesSyncDate =>
      ref.read(servicesOfWorkerSyncDate(this)); // TODO:

  /// List of services.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  // TODO: update by server policy.
  List<ServiceEntry> get services => ref.read(servicesOfWorker(this));

  /// Synchronize services for [WorkerProfile.services].
  ///
  /// TODO: Services usually updated once per year,
  /// and before calling this function
  /// we should check: is it really necessary, i.e. is [services] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [clientPlan] with wrong [ClientPlan.servId].
  Future<void> syncServices() async {
    await ref.read(repositoryHttp(apiUrlServices).notifier).getHttpData();
  }

  Future<void> syncClients() async {
    await ref.read(repositoryHttp(apiUrlClients).notifier).getHttpData();
  }

  Future<void> syncPlanned() async {
    await ref.read(repositoryHttp(apiUrlPlan).notifier).getHttpData();
  }

  /// This should only be called if there is inconsistency:
  ///
  /// [ClientPlan] had nonexist service Id. This can happen:
  /// - then list of [ServiceEntry] is reduced on server,
  /// - database has inconsistency. TODO: check it here - low priority.
  Future<void> checkAllServicesExist() async {
    return;
    //   if (_services.isEmpty) {
    //     await syncHiveServices();
    //   } else if (ref
    //       .read(servicesOfWorkerSyncDate(this))
    //       .isBefore(ref.read(planOfWorkerSyncDate(this)))) {
    //     await syncHiveServices();
    //   } else {
    //     // TODO: actual checks here
    //   }
  }
}
