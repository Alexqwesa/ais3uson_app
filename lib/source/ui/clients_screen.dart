import 'dart:async';

import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

/// Show screen with client of [WorkerProfile].
///
/// {@category UI WorkerProfiles}
class ClientScreen extends ConsumerWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerProfile = ref.watch(lastWorkerProfile);
    final clientList = ref.watch(clientsOfWorker(workerProfile));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                workerProfile.key.dep,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await workerProfile.syncClients();
              },
            ),
          ],
        ),
      ),
      body: clientList.isNotEmpty
          ? ListView.builder(
              itemCount: clientList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: 550,
                    child: ClientCard(
                      index: index,
                      client: clientList[index],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                S.of(context).emptyListOfPeople,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
    );
  }
}

class ClientCard extends ConsumerWidget {
  const ClientCard({
    required this.index,
    required this.client,
    Key? key,
  }) : super(key: key);

  final ClientProfile client;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.5,
          child: Icon(
            Icons.person,
            color: HSVColor.fromColor(
              Theme.of(context).primaryColor,
            )
                .withHue(
                  (index * 103 + 100) % 360,
                )
                .withSaturation(
                  10 / (index.toDouble() + 10),
                )
                .toColor(),
          ),
        ),
        title: Text(
          client.name,
          style: Theme.of(context).textTheme.headline5,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(25, 8, 0, 4),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              client.contract,
              // textAlign: TextAlign.right,
            ),
          ),
        ),
        onLongPress: () async {
          ref.read(lastClientId.notifier).state = client.contractId;
          unawaited(
            Navigator.pushNamed(
              context,
              '/client_journal',
            ),
          );
        },
        onTap: () async {
          ref.read(lastClientId.notifier).state = client.contractId;
          unawaited(
            Navigator.pushNamed(
              context,
              '/client_services',
            ),
          );
        },
      ),
    );
  }
}
