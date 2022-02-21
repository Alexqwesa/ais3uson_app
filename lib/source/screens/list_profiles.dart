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
  _ListOfProfiles();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppData(),
      child: Consumer<AppData>(
        builder: (context, data, child) {
          final workerKeys = context.select<AppData, List<WorkerKey>>(
            (data) => data.workerKeys.toList(),
          );

          return workerKeys.isNotEmpty
              ? ListView.builder(
                  controller: ScrollController(),
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
                          if (AppData().profiles[index].clients.isEmpty) {
                            AppData.instance.profiles[index].syncHiveClients();
                          }
                        },
                        subtitle: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workerKeys[index].name),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${workerKeys[index].comment}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Авторизируйтесь (отсканируйте QR код) ',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
        },
      ),
    );
  }
}
