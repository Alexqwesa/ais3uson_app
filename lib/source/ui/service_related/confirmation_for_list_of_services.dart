import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/ui/service_related/client_service_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:provider/provider.dart';

class ConfirmationForListOfServices extends ConsumerWidget {
  const ConfirmationForListOfServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _client = ref.watch(lastClient);

    return ChangeNotifierProvider.value(
      value: _client.workerProfile.fullArchive,
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).listOfServicesByDays)),
        body: Center(
          child: SingleChildScrollView(
            child: Consumer<JournalArchive>(
              builder: (context, value, child) {
                final all = _client.workerProfile.fullArchive.all;
                if (_client.services.isEmpty) {
                  return Container(); // Todo:
                }
                final allByGroups = groupBy<ServiceOfJournal, int>(
                  all,
                  (e) => e.provDate.daysSinceEpoch,
                );

                return Wrap(
                  children: [
                    for (final servicesAt
                        in allByGroups.entries.map((e) => e.value))
                      SizedBox(
                        width: 632,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            TitleWidgetOfServicesGroup(
                              service: servicesAt[0],
                              client: _client,
                            ),
                            for (int index = 1;
                                index < servicesAt.length;
                                index++)
                              TotalServiceTile(
                                serviceOfJournal: all[index],
                                client: _client,
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TitleWidgetOfServicesGroup extends StatelessWidget {
  const TitleWidgetOfServicesGroup({
    required this.service,
    required this.client,
    Key? key,
  }) : super(key: key);

  final ServiceOfJournal service;
  final ClientProfile client;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 632,
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
              subtitle: Container(),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TotalServiceTile(
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

class TotalServiceTile extends StatelessWidget {
  final ServiceOfJournal serviceOfJournal;
  final ClientProfile client;
  late final ClientService service;

  // ignore: sort_constructors_first
  TotalServiceTile({
    required this.serviceOfJournal,
    required this.client,
    Key? key,
  }) : super(key: key) {
    try {
      service =
          serviceOfJournal.provDate.isBefore(client.workerProfile.journal.today)
              ? client.services
                  .firstWhere(
                    (element) => element.servId == serviceOfJournal.servId,
                  )
                  .copyWith(newJournal: client.workerProfile.fullArchive)
              : client.services.firstWhere(
                  (element) => element.servId == serviceOfJournal.servId,
                );
      // ignore: avoid_catching_errors
    } on StateError catch (e) {
      if (e.message == 'No element') {
        service = client.services.first.copyWith(
          newJournal: client.workerProfile.fullArchive,
          serv: client.services.first.service.copyWith(
            image: 'not-found.png',
            short_text: locator<S>().errorService,
            serv_text: locator<S>().errorService,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: 600,
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
                    Text(service.shortText),
                  ],
                ),
              ),
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ClientServiceScreen>(
                    builder: (context) {
                      return ClientServiceScreen(
                        service: service,
                      );
                    },
                  ),
                );
                // ignore: await_only_futures
                service.proofList;
              },
            ),
          ),
        ),
      ),
    );
  }
}
