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
  late final JournalHttpInterface http;

  // late final Journal _journal;
  // late final Journal _journalAt;
  // late final Journal _journalAll;

  @override
  WorkerKey build(WorkerKey key) {
    http = JournalHttpInterface(this);
    // journal = ProviderOfJournal(this);
    return key;
  }

  Journal get journal => ref.read(journalsProvider(apiKey));

  Journal get journalOf =>
      ref.read(journalsProvider(apiKey).notifier).journalOf;

  Journal get journalAllOf =>
      ref.read(journalsProvider(apiKey).notifier).journalAllDates;

  Journal journalAtDateOf(DateTime date) =>
      ref.read(journalsProvider(apiKey).notifier).journalAtDateOf(date);

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

  // (String, String) get apiUrlClients => (apiKey, urlClients);
  //
  // (String, String) get apiUrlPlan => (apiKey, urlPlan);
  //
  // (String, String) get apiUrlServices => (apiKey, urlServices);

  /// List of services for client.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  Provider<List<ServiceEntry>> get servicesOf => _servicesOfWorker(this);

  /// List of assigned clients.
  Provider<List<ClientProfile>> get clientsOf => _clientsOfWorker(this);

  /// List of assigned clients.
  Provider<List<ClientPlan>> get clientsPlanOf => _planOfWorker(this);

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

/// Provider of clients for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
///
/// {@category Providers}
final _clientsOfWorker = Provider.family<List<ClientProfile>, Worker>(
  (ref, wp) {
    // ref.watch(httpProvider(wp.apiKey, wp.urlClients).notifier).syncHiveHttp();

    return ref
        .watch(httpProvider(wp.apiKey, wp.urlClients))
        .map<ClientEntry>(ClientEntry.fromJson)
        .map((el) => ref.watch(
            clientProfileProvider(apiKey: wp.apiKey, entry: el).notifier))
        .toList(growable: false);
  },
);

/// Provider of services for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ServiceEntry]>.
///
/// {@category Providers}
final _servicesOfWorker =
    Provider.family<List<ServiceEntry>, Worker>((ref, wp) {
  // ref.watch(httpProvider(wp.apiKey, wp.urlServices).notifier).syncHiveHttp();

  return ref
      .watch(httpProvider(wp.apiKey, wp.urlServices))
      .map<ServiceEntry>(ServiceEntry.fromJson)
      .toList(growable: false);
});

/// Provider of planned services for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
final _planOfWorker = Provider.family<List<ClientPlan>, Worker>((ref, wp) {
  // ref.watch(httpProvider(wp.apiKey, wp.urlPlan).notifier).syncHiveHttp();

  return ref
      .watch(httpProvider(wp.apiKey, wp.urlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
});
