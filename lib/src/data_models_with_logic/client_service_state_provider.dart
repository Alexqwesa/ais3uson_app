import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/src/data_models/client_service_state.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_service_state_provider.g.dart';

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
///
/// {@category Data Models}
@riverpod
ClientServiceState serviceState(Ref ref, ClientService client) {
  final journal = ref.watch(journalProvider(client.apiKey));
  final jServ = ref.watch(jServicesOfClientProvider(client));

  return ClientServiceState(
    client: client,
    ref: ref,
    isReadOnly: journal.state.isArchive,
    added: jServ[ServiceState.added]!.length,
    rejected: jServ[ServiceState.rejected]!.length,
    left: client.plan -
        client.filled -
        jServ[ServiceState.added]!.length -
        jServ[ServiceState.finished]!.length,
    // but not outDated
    done: jServ[ServiceState.finished]!.length +
        jServ[ServiceState.outDated]!.length,
  );
}

/// Return [ServiceOfJournal] grouped by type for [ClientService].
@Riverpod(keepAlive: true)
Map<ServiceState, List<ServiceOfJournal>> jServicesOfClient(
  Ref ref,
  ClientService clientService,
  // AppState archive,
) {
  // if (archive.isArchive) {
  //
  // } else {
  final journal = ref.watch(journalProvider(clientService.apiKey));
  final groups = ref.watch(servicesOfJournalProvider(journal));
  final res = groups.map(
    (key, value) => MapEntry(
      key,
      value
          .where((e) =>
              e.contractId == clientService.contractId &&
              e.servId == clientService.servId)
          .toList(growable: false),
    ),
  );

  // make sure it is not contains null
  ServiceState.values.forEach((state) {
    if (!res.containsKey(state)) {
      res[state] = [];
    }
  });

  return res;
}

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
Map<ServiceState, List<ServiceOfJournal>> servicesOfJournal(
    Ref ref, Journal journal) {
  if (journal.aData == null) {
    final journalServices =
        ref.watch(hiveRepositoryProvider(journal.workerProfile.apiKey));

    return groupBy<ServiceOfJournal, ServiceState>(
      journalServices,
      (e) => e.state,
    );
  } else {
    final journalServices =
        ref.watch(archiveReaderProvider(journal.workerProfile.apiKey));

    return groupBy<ServiceOfJournal, ServiceState>(
      journalServices.where((e) => e.provDate.dateOnly() == journal.aData),
      (e) => e.state,
    );
  }
}
