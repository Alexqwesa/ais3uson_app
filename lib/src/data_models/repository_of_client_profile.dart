// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/data_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider of list of [ClientService]s for client.
///
/// {@category Providers}
final servicesOfClient =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final listService = ref
      .watch(planOfWorker(client.workerProfile))
      .where((e) => e.contractId == client.contractId);
  final listServiceIds = listService.map((e) => e.servId);

  return ref
      .watch(servicesOfWorker(client.workerProfile))
      .where((e) => listServiceIds.contains(e.id))
      .map(
        (e) => ClientService(
          workerProfile: client.workerProfile,
          service: e,
          planned: listService.firstWhere((element) => element.servId == e.id),
          // client: client,
        ),
      )
      .toList(growable: false)
    ..sort((a, b) => a.servId.compareTo(b.servId)); // preserve id order
});
