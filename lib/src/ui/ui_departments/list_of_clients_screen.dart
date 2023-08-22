import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

/// Show screen with client of [Worker].
///
/// {@category UI Workers}
class ListOfClientsScreen extends ConsumerWidget {
  final Worker workerProfile;

  const ListOfClientsScreen({required this.workerProfile, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientList = ref.watch(workerProfile.clientsOf);

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
              // ignore: avoid-passing-async-when-sync-expected
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
                      department: workerProfile,
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
  final ClientProfile client;
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
