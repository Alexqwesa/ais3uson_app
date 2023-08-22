import 'dart:async';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

part 'worker_profile_logic.g.dart';

@riverpod
Worker workerByApi(Ref ref, String apiKey) =>
    ref.watch(departmentsProvider.notifier).byApi(apiKey);

/// Extension of [Worker] with providers:
/// [] - provider of list of [ClientProfile].
///
/// {@category Data Models}
@Riverpod(keepAlive: true)
class Worker extends _$Worker {
  late final JournalHttpRepository httpRepository;
  late final ProviderOfJournal journalProvider;

  HiveRepository get hiveRepository =>
      ref.watch(hiveRepositoryProvider(apiKey).notifier);

  WorkerKey get workerKey => state;

  String get shortName =>
      ref.watch(departmentsProvider.notifier).getShortNameByApi(apiKey);

  Provider<Journal> get journalOf => journalProvider.journalOf;

  // get journal => ref.watch(journalProvider());

  Provider<Journal> get journalAllOf => journalProvider.journalAllOf;

  String get apiKey => key.apiKey;

  String get name => key.name;

  String get hiveName => 'journal_$apiKey';

  String get urlClients => '${key.activeServer}/clients';

  String get urlPlan => '${key.activeServer}/planned';

  String get urlServices => '${key.activeServer}/services';

  Tuple2<WorkerKey, String> get apiUrlClients => Tuple2(key, urlClients);

  Tuple2<WorkerKey, String> get apiUrlPlan => Tuple2(key, urlPlan);

  Tuple2<WorkerKey, String> get apiUrlServices => Tuple2(key, urlServices);

  Provider<Journal> journalAtDateOf(DateTime date) =>
      journalProvider.journalAtDateOf(date);

  @override
  WorkerKey build(WorkerKey key) {
    httpRepository = JournalHttpRepository(this);
    journalProvider = ProviderOfJournal(this);
    return key;
  }

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

  Provider<DateTime> get planSyncDateOf => _planOfWorkerSyncDate(this);

  DateTime get servicesSyncDate =>
      ref.read(_servicesOfWorkerSyncDate(this)); // TODO:

  /// Synchronize List<[ServiceEntry]> of worker.
  ///
  /// TODO: Services usually updated once per year,
  /// and before calling this function
  /// we should check: is it really necessary, i.e. is [servicesOf] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [clientsPlanOf] with wrong [ClientPlan.servId].
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

/// DateTime of last update of [Worker.clientsPlanOf].
///
/// {@category Providers}
final _planOfWorkerSyncDate = Provider.family<DateTime, Worker>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlPlan));
});

/// DateTime of last update of [Worker.servicesOf].
///
/// {@category Providers}
final _servicesOfWorkerSyncDate = Provider.family<DateTime, Worker>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlServices));
});

/// Provider of clients for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
///
/// {@category Providers}
final _clientsOfWorker = Provider.family<List<ClientProfile>, Worker>(
  (ref, wp) {
    ref.watch(repositoryHttp(wp.apiUrlClients).notifier).syncHiveHttp();

    return ref
        .watch(repositoryHttp(wp.apiUrlClients))
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
  ref.watch(repositoryHttp(wp.apiUrlServices).notifier).syncHiveHttp();

  return ref
      .watch(repositoryHttp(wp.apiUrlServices))
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
  ref.watch(repositoryHttp(wp.apiUrlPlan).notifier).syncHiveHttp();

  return ref
      .watch(repositoryHttp(wp.apiUrlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
});
