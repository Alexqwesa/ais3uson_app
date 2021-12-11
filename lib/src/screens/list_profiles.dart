import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/user_key.dart';
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
  // var itemCount = AppData.instance.userKeys.length;
  // List<UserKey> userKeys = AppData.instance.userKeys.toList();
  _ListOfProfiles();

  @override
  Widget build(BuildContext context) {
    // return Consumer<AppData>(
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Consumer<AppData>(builder: (context, data, child) {
        // List<FioEntry> fioList = data.profiles[profileNum].fioList;
        final userKeys = context.select<AppData, List<UserKey>>(
          (data) => data.userKeys.toList(),
        );

        return userKeys.isNotEmpty
            ? ListView.builder(
                itemCount: userKeys.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(userKeys[index].otd),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/department',
                        arguments: ScreenArguments(profile: index),
                      );
                    },
                    // subtitle: Container(width: 48, height: 48),
                  );
                },
              )
            : const Center(
                child: Text('Авторизируйтесь (отсканируйте QR код) '),
              );
      }),
    );
  }
}
