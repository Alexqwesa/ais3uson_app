import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Create a list of Services of client List<[ClientService]>.
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
