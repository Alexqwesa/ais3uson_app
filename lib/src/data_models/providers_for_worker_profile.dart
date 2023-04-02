import 'dart:core';

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider of clients for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
///
/// {@category Providers}
final clientsOfWorker = Provider.family<List<ClientProfile>, WorkerProfile>(
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
final servicesOfWorker =
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
final planOfWorker =
    Provider.family<List<ClientPlan>, WorkerProfile>((ref, wp) {
  ref.watch(repositoryHttp(wp.apiUrlPlan).notifier).syncHiveHttp();

  return ref
      .watch(repositoryHttp(wp.apiUrlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
});
