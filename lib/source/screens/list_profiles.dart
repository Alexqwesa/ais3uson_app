import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
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
      child: Consumer<AppData>(
        builder: (context, data, child) {
          // List<ClientEntry> fioList = data.profiles[profileNum].fioList;
          final workerKeys = context.select<AppData, List<WorkerKey>>(
            (data) => data.workerKeys.toList(),
          );

          return workerKeys.isNotEmpty
              ? ListView.builder(
                  itemCount: workerKeys.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform.scale(
                            scale: 2,
                            child: const Icon(Icons.group),
                          ),
                        ),
                        title: Text(
                          workerKeys[index].dep,
                          style: Theme.of(context).textTheme.headline6,
                        ),

                        // visualDensity:
                        //     VisualDensity(horizontal: 1, vertical: 1),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/department',
                            arguments: ScreenArguments(profile: index),
                          );
                        },
                        subtitle: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workerKeys[index].name),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Какой-нибудь текст'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Авторизируйтесь (отсканируйте QR код) '),
                );
        },
      ),
    );
  }
}
