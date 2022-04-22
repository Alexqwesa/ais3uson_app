import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Create ProofList for [ClientService].
///
/// {@category Providers}
final proofsOfServices =
    Provider.family<ProofList, ClientService>((ref, service) {
  return ProofList(
    service.workerDepId,
    service.contractId,
    standardFormat.format(DateTime.now()),
    service.servId,
    client: service.journal.workerProfile.clients
        .firstWhere((element) => element.contractId == service.contractId)
        .name,
    worker: service.journal.workerProfile.name,
    service: service.shortText,
  );
});
