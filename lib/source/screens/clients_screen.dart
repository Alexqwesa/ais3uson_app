import 'dart:async';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show screen with client of [WorkerProfile].
///
/// {@category WorkerProfiles}
class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppData.instance.getLastWorker(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).loading)),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          final workerProfile = snapshot.data as WorkerProfile;

          return ChangeNotifierProvider<WorkerProfile>.value(
            value: workerProfile,
            child: Scaffold(
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
                        await workerProfile.syncHiveClients();
                      },
                    ),
                  ],
                ),
              ),
              body: Consumer<WorkerProfile>(
                //
                // > get data
                //
                builder: (context, data, child) {
                  final clientList =
                      context.select<WorkerProfile, List<ClientProfile>>(
                    (data) => data.clients.toList(),
                  );

                  //
                  // > build list
                  //
                  return clientList.isNotEmpty
                      ? ListView.builder(
                          itemCount: clientList.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: SizedBox(
                                width: 550.0,
                                child: ClientCardWidgetOfList(
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
                        );
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).error),
            ),
          );
        }
      },
    );
  }
}

class ClientCardWidgetOfList extends StatelessWidget {
  final ClientProfile client;
  final int index;

  const ClientCardWidgetOfList({
    required this.index,
    required this.client,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workerProfile = client.workerProfile;

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
          padding: const EdgeInsets.fromLTRB(25.0, 8, 0, 4),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              client.contract,
              // textAlign: TextAlign.right,
            ),
          ),
        ),
        onTap: () async {
          AppData.instance.lastClient = client;
          unawaited(Navigator.pushNamed(
            context,
            '/client_services',
            arguments: ScreenArguments(
              profile: client.workerProfile.index,
              contract: client.contractId,
            ),
          ));
          await AppData.instance.setLastClient(client);
          if (workerProfile.services.isEmpty) {
            await workerProfile.syncHiveServices();
          }
          if (workerProfile.clientPlan.isEmpty) {
            await workerProfile.syncHivePlanned();
          }
          final clientProfile = client;
          if (clientProfile.services.isEmpty) {
            await clientProfile.updateServices();
          }
        },
      ),
    );
  }
}
