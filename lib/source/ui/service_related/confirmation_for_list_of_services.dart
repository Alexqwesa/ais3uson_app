import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/ui/service_related/client_service_screen.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

const tileSize = 500.0;

class ConfirmationForServicesScreen extends ConsumerWidget {
  const ConfirmationForServicesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastClient);
    final all = ref.watch(fullArchiveOfClient(client));
    final allByGroups = groupBy<ServiceOfJournal, int>(
      all,
      (e) => e.provDate.daysSinceEpoch,
    );

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).listOfServicesByDays)),
      body: Center(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              if (client.services.isEmpty || all.isEmpty)
                Text(locator<S>().emptyListOfServices),
              for (final servicesAt in allByGroups.entries.map((e) => e.value))
                SizedBox(
                  width: tileSize + 32,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TitleWidgetOfServicesGroup(
                        service: servicesAt[0],
                        client: client,
                      ),
                      for (int index = 1; index < servicesAt.length; index++)
                        ServiceOfJournalTile(
                          serviceOfJournal: servicesAt[index],
                          client: client,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleWidgetOfServicesGroup extends ConsumerWidget {
  const TitleWidgetOfServicesGroup({
    required this.service,
    required this.client,
    Key? key,
  }) : super(key: key);

  final ServiceOfJournal service;
  final ClientProfile client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final stubService = ref.watch(servicesOfClient(client)).first.copyWith(
    //         service: const ServiceEntry(
    //       serv_text: 'Stub',
    //       id: 0,
    //     ));

    return SizedBox(
      width: tileSize + 32,
      child: Stack(
        children: [
          SizedBox(
            height: 110,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              title: Text(
                ' ${standardFormat.format(service.provDate)}',
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Column(
                children: const [
                  // if (!kIsWeb)
                  //   ServiceProofList(
                  //     clientService: stubService,
                  //     // date: service.provDate,
                  //   ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ServiceOfJournalTile(
                serviceOfJournal: service,
                client: client,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Show [ServiceOfJournal] as Tile widget
class ServiceOfJournalTile extends ConsumerWidget {
  const ServiceOfJournalTile({
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
      // if (e.message == 'No element') {
      service = ClientService(
        // maybe use error constructor?
        workerProfile: client.workerProfile,
        service: client.services.first.service.copyWith(
          image: 'not-found.png',
          short_text: locator<S>().errorService,
          serv_text: locator<S>().errorService,
        ),
        planned: client.services.first.planned,
        //date: serviceOfJournal.provDate
      );
      // }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: tileSize,
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
              onTap: () => tapHandler(context, service),
              onLongPress: () => tapHandler(context, service),
            ),
          ),
        ),
      ),
    );
  }

  void tapHandler(BuildContext context, ClientService service) {
    Navigator.push(
      context,
      MaterialPageRoute<ClientServiceScreen>(
        builder: (context) {
          return ClientServiceScreen(
            clientService: service,
            serviceDate: serviceOfJournal.provDate,
          );
        },
      ),
    );
    service.proofList;
  }
}
