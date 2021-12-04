import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/user_key.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import 'list_fio.dart';

class ListOfProfiles extends StatefulWidget {
  const ListOfProfiles({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListOfProfiles();
  }
}

class _ListOfProfiles extends State<ListOfProfiles> {
  var itemCount = AppData.instance.userKeys.length;
  List<UserKey> userKeys = AppData.instance.userKeys.toList();

  _ListOfProfiles() {
    AppData.instance.updStreamUK.listen((b) {
      updateUKeys(b);
    });
  }

  void updateUKeys(bool b) {
    setState(() {
      itemCount = AppData.instance.profiles.length;
      userKeys = AppData.instance.userKeys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return itemCount > 0
        ? ListView.builder(
            itemCount: itemCount,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(Icons.group),
                title: Text(userKeys[index].otd),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListFio(
                              profileNum: index,
                            )),
                  );
                },
                // subtitle: Container(width: 48, height: 48),
              );
            },
          )
        : const Center(child: Text('Авторизируйтесь (отсканируйте QR код) '));
  }
}
