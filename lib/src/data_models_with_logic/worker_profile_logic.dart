import 'dart:async';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Extension of [ClientProfile] with providers:
/// [] - provider of list of [ClientService].
///
///
/// {@category Data Models}
extension WorkerProfileLogic on WorkerProfile {
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

/// DateTime of last update of [WorkerProfileLogic.clientsPlanOf].
///
/// {@category Providers}
final _planOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlPlan));
});

/// DateTime of last update of [WorkerProfileLogic.servicesOf].
///
/// {@category Providers}
final _servicesOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastHttpUpdate(wp.apiKey + wp.urlServices));
});

/// Provider of clients for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
///
/// {@category Providers}
final _clientsOfWorker = Provider.family<List<ClientProfile>, WorkerProfile>(
  (ref, wp) {
    ref.watch(repositoryHttp(wp.apiUrlClients).notifier).syncHiveHttp();

    return ref
        .watch(repositoryHttp(wp.apiUrlClients))
        .map<ClientEntry>(ClientEntry.fromJson)
        .map((el) => ClientProfile(workerProfile: wp, entry: el))
        .toList(growable: false);
  },
);

/// Provider of services for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ServiceEntry]>.
///
/// {@category Providers}
final _servicesOfWorker =
    Provider.family<List<ServiceEntry>, WorkerProfile>((ref, wp) {
  ref.watch(repositoryHttp(wp.apiUrlServices).notifier).syncHiveHttp();

  return ref
      .watch(repositoryHttp(wp.apiUrlServices))
      .map<ServiceEntry>(ServiceEntry.fromJson)
      .toList(growable: false);
});

/// Provider of planned services for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
final _planOfWorker =
    Provider.family<List<ClientPlan>, WorkerProfile>((ref, wp) {
  ref.watch(repositoryHttp(wp.apiUrlPlan).notifier).syncHiveHttp();

  return ref
      .watch(repositoryHttp(wp.apiUrlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
});
