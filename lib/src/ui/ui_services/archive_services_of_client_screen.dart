// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_proofs.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, ProviderScope, WidgetRef;

const _tileSize = 500.0;

/// Display all service of client (today + archive).
///
/// Also allow to create proof at date(for all services at day).
///
/// {@category UI Services}
class ArchiveServicesOfClientScreen extends ConsumerWidget {
  const ArchiveServicesOfClientScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastUsed).client;
    final all = ref.watch(journalOfClient(client));
    final allByGroups = groupBy<ServiceOfJournal, int>(
      all,
      (e) => e.provDate.daysSinceEpoch,
    );

    return Scaffold(
      appBar: AppBar(title: Text(tr().listOfServicesByDays)),
      body: all.isEmpty
          ? Center(
              child: Text(
                tr().emptyListOfServices,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Wrap(
                  children: [
                    for (final serviceDayGroup
                        in allByGroups.entries.map((e) => e.value))
                      SizedBox(
                        width: _tileSize + 32,
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _TitleWidgetOfServicesGroup(
                                service: serviceDayGroup[0],
                                client: client,
                              ),
                              for (int index = 1;
                                  index < serviceDayGroup.length;
                                  index++)
                                _ServiceOfJournalTile(
                                  serviceOfJournal: serviceDayGroup[index],
                                  client: client,
                                ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _TitleWidgetOfServicesGroup extends StatelessWidget {
  const _TitleWidgetOfServicesGroup({
    required this.service,
    required this.client,
    Key? key,
  }) : super(key: key);

  final ServiceOfJournal service;
  final ClientProfile client;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _tileSize + 32,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              children: [
                //
                // > Date
                //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ' ${standardFormat.format(service.provDate)}',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
                //
                // > Audio Proof Buttons
                //
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      AudioProofController(
                        client: client,
                        service: service,
                        // beforeOrAfter: 'after_audio_',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //
            // > service tile
            //
            Align(
              alignment: Alignment.bottomCenter,
              child: _ServiceOfJournalTile(
                serviceOfJournal: service,
                client: client,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show [ServiceOfJournal] as Tile widget.
class _ServiceOfJournalTile extends ConsumerWidget {
  const _ServiceOfJournalTile({
    required this.serviceOfJournal,
    required this.client,
    Key? key,
  }) : super(key: key);

  /// Core variable
  final ServiceOfJournal serviceOfJournal;
  final ClientProfile client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ClientService service;

    try {
      service = ref.watch(servicesOfClient(client)).firstWhere(
            (element) => element.servId == serviceOfJournal.servId,
          );
      // ignore: avoid_catching_errors
    } on StateError {
      service = ClientService(
        // maybe use error constructor?
        workerProfile: client.workerProfile,
        service: ServiceEntry(
          id: 0,
          serv_text: tr().errorService,
          short_text: tr().errorService,
          image: 'not-found.png',
        ),
        planned:
            const ClientPlan(contract_id: 0, serv_id: 0, planned: 0, filled: 0),
      );
      // }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: _tileSize,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: SizedBox(
            height: 60,
            child: InkWell(
              child: Card(
                margin: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Image.asset(
                      'images/${service.image}',
                    ),
                    Expanded(
                      child: Text(
                        service.shortText,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => openClientServiceScreen(context, service, ref),
              onLongPress: () => openClientServiceScreen(context, service, ref),
            ),
          ),
        ),
      ),
    );
  }

  /// Open [ClientServiceScreen] without setting lastUsed (for serviceOfJournal).
  void openClientServiceScreen(
    BuildContext context,
    ClientService service,
    WidgetRef _,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute<ClientServiceScreen>(
        builder: (context) {
          return ProviderScope(
            child: const ClientServiceScreen(),
            overrides: [
              currentService.overrideWithValue(
                service.copyWith(date: serviceOfJournal.provDate.dateOnly()),
              ),
            ],
          );
        },
      ),
    );
    service.proofList;
  }
}
