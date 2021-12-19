import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/worker_key.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProfiles extends StatefulWidget {
  const ListOfProfiles({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListOfProfiles();
  }
}

class _ListOfProfiles extends State<ListOfProfiles> {
  // var itemCount = AppData.instance.workerKeys.length;
  // List<WorkerKey> workerKeys = AppData.instance.workerKeys.toList();
  _ListOfProfiles();

  @override
  Widget build(BuildContext context) {
    // return Consumer<AppData>(
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Consumer<AppData>(builder: (context, data, child) {
        // List<FioEntry> fioList = data.profiles[profileNum].fioList;
        final workerKeys = context.select<AppData, List<WorkerKey>>(
          (data) => data.workerKeys.toList(),
        );

        return workerKeys.isNotEmpty
            ? ListView.builder(
                itemCount: workerKeys.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(workerKeys[index].otd),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/department',
                          arguments: ScreenArguments(profile: index),
                        );
                      },
                      subtitle: Text(workerKeys[index].name),);
                },
              )
            : const Center(
                child: Text('Авторизируйтесь (отсканируйте QR код) '),
              );
      }),
    );
  }
}
