import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_services.dart';
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
    final workerProfile = ref.watch(lastUsed).worker;
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
                tr().emptyListOfPeople,
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
        onLongPress: () {
          ref.read(lastUsed).client = client;
          Navigator.pushNamed(
            context,
            '/client_journal',
          );
        },
        onTap: () {
          ref.read(lastUsed).client = client;
          ref.read(currentSearchText.notifier).state = '';
          Navigator.pushNamed(
            context,
            '/client_services',
          );
        },
      ),
    );
  }
}
