import 'dart:ui';

import 'package:ais3uson_app/source/data_classes/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FioScreen extends StatefulWidget {
  const FioScreen({Key? key}) : super(key: key);

  @override
  _FioScreenState createState() => _FioScreenState();
}

class _FioScreenState extends State<FioScreen> {
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
                  await workerProfile.syncHiveFio();
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
            if (clientList.isEmpty) {
              workerProfile.syncHiveFio();
            }
            
            // 
            // > build list 
            // 
            return
                clientList.isNotEmpty
                    ? ListView.builder(
                        itemCount: clientList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                              clientList[index].name,
                            ),
                            onTap: () {
                              if (workerProfile.services.isEmpty) {
                                workerProfile.syncHiveServices();
                              }
                              Navigator.pushNamed(
                                context,
                                '/fio_services',
                                arguments: ScreenArguments(
                                  profile: profileNum,
                                  contract: clientList[index].contractId,
                                ),
                              );
                            },
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
