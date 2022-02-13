import 'dart:async';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final profileNum = args.profileNum;
    final workerProfile = AppData.instance.profiles[profileNum];

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
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.fromLTRB(8, 1, 8, 0),
                        child: ListTile(
                          leading: Transform.scale(
                            scale: 1.5,
                            child: const Icon(Icons.person),
                          ),
                          title: Text(
                            clientList[index].name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              clientList[index].contract,
                              // textAlign: TextAlign.right,
                            ),
                          ),
                          onTap: () async {
                            unawaited(Navigator.pushNamed(
                              context,
                              '/client_services',
                              arguments: ScreenArguments(
                                profile: profileNum,
                                contract: clientList[index].contractId,
                              ),
                            ));
                            if (workerProfile.services.isEmpty) {
                              await workerProfile.syncHiveServices();
                            }
                            if (workerProfile.clientPlan.isEmpty) {
                              await workerProfile.syncHivePlanned();
                            }
                            final clientProfile = clientList[index];
                            if (clientProfile.services.isEmpty) {
                              await clientProfile.updateServices();
                            }
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Список получателей СУ пуст, \n\n'
                      'попросите заведующего отделением добавить людей в ваш список обслуживаемых и \n\n'
                      'обновите список',
                      textAlign: TextAlign.center,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
