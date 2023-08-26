// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'worker.g.dart';

@Riverpod(keepAlive: true)
Worker workerByApi(Ref ref, String apiKey) =>
    ref.watch(departmentsProvider.notifier).byApi(apiKey);

/// Extension of [Worker] with providers:
/// [] - provider of list of [ClientProfile].
///
/// {@category Data Models}
@Riverpod(keepAlive: true)
class Worker extends _$Worker {
  JournalHttpInterface get http => JournalHttpInterface(
      wKey: state, http: ref.read(httpClientProvider(state.certBase64)));

  @override
  WorkerKey build(WorkerKey key) {
    return key;
  }

  Journal get journal => ref.watch(journalProvider(apiKey));

  Journal get journalOf => journal; // JournalArchive(worker, appState);

  Journal get journalAllOf => journal; // JournalArchiveAll(worker, appState);

  Journal journalAtDateOf(DateTime date) => journal; // change AppState
  // _journalNotifier.journalAtDateOf(date);

  HiveRepository get hiveRepository =>
      ref.watch(hiveRepositoryProvider(apiKey).notifier);

  WorkerKey get workerKey => state;

  String get shortName =>
      ref.watch(departmentsProvider.notifier).getShortNameByApi(apiKey);

  // get journal => ref.watch(journalProvider());

  String get apiKey => key.apiKey;

  String get name => key.name;

  String get hiveName => 'journal_$apiKey';

  String get urlClients => '/clients';

  String get urlPlan => '/planned';

  String get urlServices => '/services';

  /// List of services(it names), one for all clients.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  ServicesOfWorkerProvider get servicesOf => servicesOfWorkerProvider(this);

  /// List of assigned clients.
  ClientsOfWorkerProvider get clientsOf => clientsOfWorkerProvider(this);

  /// List plans of assigned clients.
  PlanOfWorkerProvider get clientsPlanOf => planOfWorkerProvider(this);

  DateTime get planSyncDateOf =>
      ref.watch(httpProvider(apiKey, urlPlan).notifier).updatedAt;

  // DateTime get servicesSyncDate => ref.watch(httpProvider(apiKey, urlServices).notifier).updatedAt;

  /// Synchronize List<[ServiceEntry]> of worker.
  ///
  /// TODO: Services usually updated once per year,
  /// and before calling this function
  /// we should check: is it really necessary, i.e. is [servicesOf] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [clientsPlanOf] with wrong [ClientPlan.servId].
  Future<void> syncServices() async {
    await ref.watch(httpProvider(apiKey, urlServices).notifier).update();
  }

  Future<void> syncClients() async {
    await ref.watch(httpProvider(apiKey, urlClients).notifier).update();
  }

  Future<void> syncPlanned() async {
    await ref.watch(httpProvider(apiKey, urlPlan).notifier).update();
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

/// Provider of clients for a [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
List<ClientProfile> ClientsOfWorker(Ref ref, Worker wp) {
  // ref.watch(httpProvider(wp.apiKey, wp.urlClients).notifier).syncHiveHttp();

  return ref
      .watch(httpProvider(wp.apiKey, wp.urlClients))
      .map<ClientEntry>(ClientEntry.fromJson)
      .map((el) => ref
          .watch(clientProfileProvider(apiKey: wp.apiKey, entry: el).notifier))
      .toList(growable: false);
}

/// Provider of services for a [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
List<ServiceEntry> ServicesOfWorker(Ref ref, Worker wp) {
  // ref.watch(httpProvider(wp.apiKey, wp.urlServices).notifier).syncHiveHttp();

  return ref
      .watch(httpProvider(wp.apiKey, wp.urlServices))
      .map<ServiceEntry>(ServiceEntry.fromJson)
      .toList(growable: false);
}

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
List<ClientPlan> PlanOfWorker(Ref ref, Worker wp) {
  // ref.watch(httpProvider(wp.apiKey, wp.urlPlan).notifier).syncHiveHttp();

  return ref
      .watch(httpProvider(wp.apiKey, wp.urlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
}
