// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'worker_provider.g.dart';

class WorkerState {
  // final List<ServiceEntry> services;
  // final List<ClientPlan> planned;
  // final List<Client> clients;

  List<ServiceEntry> get services => ref.watch(_servicesOfWorkerProvider(apiKey));

  List<ClientPlan> get planned => ref.watch(_planOfWorkerProvider(apiKey));

  List<Client> get clients => ref.watch(_clientsOfWorkerProvider(apiKey));

  final WorkerKey key;

  final Ref ref;

  // JournalHttpInterface http;

  WorkerState({
    required this.ref,
    required this.key,
    // required this.services,
    // required this.planned,
    // required this.clients,
    // required this.http,
  });

  Journal get journalAll =>
      ref.watch(workerProvider(key.apiKey).notifier).journal;

  Journal get journal => ref.watch(workerProvider(key.apiKey).notifier).journal;

  String get shortName => ref
      .watch(workerKeysProvider)
      .aliases[ref.watch(workerKeysProvider).apiKeys.indexOf(key.apiKey)];

  String get apiKey => key.apiKey;
}

/// Provider of [WorkerState] and functions to manage worker tasks:
///
/// {@category Data Models}
@Riverpod(keepAlive: true)
class Worker extends _$Worker {
  JournalHttpInterface get http => JournalHttpInterface(
      wKey: state.key,
      http: ref.read(httpClientProvider(state.key.certBase64)));

  WorkerKey get key => state.key;

  @override
  WorkerState build(String apiKey) {
    return WorkerState(
      ref: ref,
      key: ref.read(workerKeysProvider).byApiKey(apiKey),
      // services: ref.read(_servicesOfWorkerProvider(apiKey)),
      // planned: ref.read(_planOfWorkerProvider(apiKey)),
      // clients: ref.read(_clientsOfWorkerProvider(apiKey)),
    );
  }

  Journal get journal => ref.watch(journalProvider(apiKey));

  Journal get journalAllOf => JournalArchiveAll(
      ref: ref, apiKey: apiKey, state: AppState.archiveAll(ref));

  Journal journalAtDate(DateTime date) => JournalArchive(
      ref: ref, apiKey: apiKey, state: AppState.archiveDate(ref, date));

  WorkerKey get workerKey => state.key;

  String get shortName => state.shortName;

  // get journal => ref.watch(journalProvider());

  String get name => key.name;

  // String get hiveName => 'journal_$apiKey';

  static String urlClients = '/clients';
  static String urlPlan = '/planned';
  static String urlServices = '/services';

  /// List of services(it names), one for all clients.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  List<ServiceEntry> get servicesOf => state.services;

  /// List of assigned clients.
  List<Client> get clients => state.clients;

  /// List plans of assigned clients.
  List<ClientPlan> get clientsPlanOf => state.planned;

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
List<Client> _ClientsOfWorker(Ref ref, String apiKey) {
  return ref
      .watch(httpProvider(apiKey, Worker.urlClients))
      .map<ClientEntry>(ClientEntry.fromJson)
      .map(
          (el) => ref.watch(clientProvider(apiKey: apiKey, entry: el).notifier))
      .toList(growable: false);
}

/// Provider of services for a [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
List<ServiceEntry> _ServicesOfWorker(Ref ref, String apiKey) {
  return ref
      .watch(httpProvider(apiKey, Worker.urlServices))
      .map<ServiceEntry>(ServiceEntry.fromJson)
      .toList(growable: false);
}

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
List<ClientPlan> _PlanOfWorker(Ref ref, String apiKey) {
  return ref
      .watch(httpProvider(apiKey, Worker.urlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
}
