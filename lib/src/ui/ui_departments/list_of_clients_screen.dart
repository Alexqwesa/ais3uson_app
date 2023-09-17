import 'dart:async';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Show screen with client of [Worker].
///
/// {@category UI Workers}
class ListOfClientsScreen extends ConsumerWidget {
  final String apiKey;

  const ListOfClientsScreen({required this.apiKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerState = ref.watch(workerProvider(apiKey));
    final clientList = workerState.clients;
    final worker = ref.watch(workerProvider(apiKey).notifier);
    // didn't work:
    // final clientList =
    //     ref.watch(workerProvider(apiKey).select((value) => value.clients));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                worker.key.dep,
              ),
            ),
            IconButton(
                icon: const Icon(Icons.refresh),
                // ignore: avoid-passing-async-when-sync-expected
                onPressed: () => unawaited(worker.syncClients())),
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
                      department: worker,
                      index: index,
                      client: clientList[index],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                tr().emptyListOfPeople,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
    );
  }
}

class ClientCard extends ConsumerWidget {
  const ClientCard({
    required this.department,
    required this.index,
    required this.client,
    super.key,
  });

  final Worker department;
  final Client client;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.5,
          //
          // > colorful icons
          //
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
          style: Theme.of(context).textTheme.headlineSmall,
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
        onLongPress: () {
          context.push(
            '/department/${department.shortName}/client/${client.contractId}/journal',
          );
        },
        onTap: () {
          context.push(
            '/department/${department.shortName}/client/${client.contractId}',
          );
        },
      ),
    );
  }
}
