import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/providers/repository_of_prooflist.dart';
import 'package:ais3uson_app/source/ui/service_related/client_service_screen.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

const tileSize = 500.0;

/// Display all service of client (today + archive).
///
/// Also allow to create proof at date(for all services at day).
///
/// {@category UI Services}
class AllServicesOfClientScreen extends ConsumerWidget {
  const AllServicesOfClientScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastClient);
    final all = ref.watch(journalOfClient(client));
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
              if (all.isEmpty) Text(locator<S>().emptyListOfServices),
              for (final serviceDayGroup
                  in allByGroups.entries.map((e) => e.value))
                SizedBox(
                  width: tileSize + 32,
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
      width: tileSize + 32,
      // height: 160,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                // > Date
                //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ' ${standardFormat.format(service.provDate)}',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                //
                // > Proof Buttons
                //
                AudioProofButtons(
                  client: client,
                  date: service.provDate,
                  beforeOrAfter: 'after_audio_',
                ),
              ],
            ),
            //
            // > Service
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

/// Buttons to make/play/share audio proofs of service.
///
/// {@category UI Services}
/// {@category UI Proofs}
class AudioProofButtons extends ConsumerWidget {
  const AudioProofButtons({
    required this.date,
    required this.client,
    required this.beforeOrAfter,
    Key? key,
  }) : super(key: key);

  final DateTime date;
  final ClientProfile client;
  final String beforeOrAfter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proof = ref.watch(proofAtDate(Tuple2(date.dateOnly(), client)));
    final proofList = ref.watch(groupsOfProof(proof));
    final player = AudioPlayer();
    final recorder = ref.watch(proofRecorder);
    // only needed to trigger rebuild
    // ignore: unused_local_variable
    final recorderState = ref.watch(proofRecorderState);
    final proofEntry = proofList[0]; // allow only one audio proof

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          //
          // > record button
          //
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: FloatingActionButton(
              heroTag: null,
              // tooltip: ,
              child: const Icon(Icons.record_voice_over_sharp),
              backgroundColor:
                  recorder.color(proofList.isNotEmpty ? proofList.first : null),
              onPressed: () async {
                if (ref.read(proofRecorderState) != RecorderState.ready) {
                  await recorder.stop();
                } else {
                  if (proofList.isEmpty) {
                    proof.addNewGroup();
                  }

                  await recorder.start(proof.proofGroups.first);
                }
              },
            ),
          ),
          //
          // > play button
          //
          if (proofList.isNotEmpty && proofEntry[beforeOrAfter] != null)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FloatingActionButton(
                heroTag: null,
                // tooltip: ,
                backgroundColor:
                    recorderState == RecorderState.ready ? null : Colors.grey,
                child: const Icon(Icons.play_arrow),
                onPressed: () async {
                  await recorder.stop();
                  if (proofEntry[beforeOrAfter] != null) {
                    await player.play(
                        DeviceFileSource(proofEntry[beforeOrAfter] as String));
                  }
                },
              ),
            ),
          //
          // > share button
          //
          if (proofList.isNotEmpty && proofEntry[beforeOrAfter] != null)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FloatingActionButton(
                heroTag: null,
                // tooltip: ,
                backgroundColor:
                    recorderState == RecorderState.ready ? null : Colors.grey,
                child: const Icon(Icons.share),
                onPressed: () async {
                  await recorder.stop();
                  if (proofEntry[beforeOrAfter] != null) {
                    final filePath = proofEntry[beforeOrAfter] as String;
                    try {
                      await Share.shareFiles([filePath]);
                      // ignore: avoid_catching_errors
                    } on UnimplementedError {
                      showNotification(
                        locator<S>().fileSavedTo + filePath,
                        duration: const Duration(seconds: 10),
                      );
                    } on MissingPluginException {
                      showNotification(
                        locator<S>().fileSavedTo + filePath,
                        duration: const Duration(seconds: 10),
                      );
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Show [ServiceOfJournal] as Tile widget
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
      // if (e.message == 'No element') {
      service = ClientService(
        // maybe use error constructor?
        workerProfile: client.workerProfile,
        service: ServiceEntry(
          id: 0,
          serv_text: locator<S>().errorService,
          short_text: locator<S>().errorService,
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
              onTap: () => openClientServiceScreen(context, service),
              onLongPress: () => openClientServiceScreen(context, service),
            ),
          ),
        ),
      ),
    );
  }

  /// Open [ClientServiceScreen] without setting lastUsed (for serviceOfJournal).
  void openClientServiceScreen(BuildContext context, ClientService service) {
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
