import 'dart:ui';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/client_profile.dart';
import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:ais3uson_app/src/global.dart';
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

    return ChangeNotifierProvider<WorkerProfile>.value(
      value: AppData().profiles[profileNum],
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Expanded(
              child: Text(
                AppData.instance.profiles[profileNum].key.dep,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await AppData.instance.profiles[profileNum].syncHiveFio();
              },
            ),
          ]),
        ),
        body: Consumer<WorkerProfile>(
          builder: (context, data, child) {
            final clientList =
                context.select<WorkerProfile, List<ClientProfile>>(
              (data) => data.clients.toList(),
            );
            if (clientList.isEmpty) {
              AppData.instance.profiles[profileNum].syncHiveFio();
            }

            return
                // Selector<AppData, List<FioEntry>>(
                //   selector: (_, model) => model.profiles[profileNum].clientList,
                //   builder: (context, clientList, _) {return
                //
                //
                //   List<FioEntry> clientList = context.select<AppData, List<FioEntry>>(
                //         (data) => data.profiles[profileNum].clientList,
                // );
                //     dev.log(clientList.toString());
                //   dev.log(AppData().profiles[profileNum].clientList.toString());
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
                              if (AppData.instance.services.isEmpty) {
                                AppData()
                                    .profiles[profileNum]
                                    .syncHiveServices();
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
                    : const Text(
                        'Список получателей СУ пуст, \n\n'
                        'попросите заведующего отделением добавить людей в ваш список обслуживаемых и \n\n'
                        'обновите список',
                        textAlign: TextAlign.center,
                      );
          },
        ),
      ),
    );
  }
}
