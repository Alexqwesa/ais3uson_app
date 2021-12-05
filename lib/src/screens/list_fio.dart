import 'dart:async';
import 'dart:ui';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/fio_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListFio extends StatefulWidget {
  const ListFio({Key? key, required this.profileNum}) : super(key: key);

  final int profileNum;

  @override
  _ListFioState createState() => _ListFioState(profileNum);
}

class _ListFioState extends State<ListFio> {
  // List<FioEntry> fioList = [];

  // int itemCount = 0;
  final int profileNum;

  // late StreamSubscription streamListener;

  _ListFioState(this.profileNum) {
    super.initState();
    //   itemCount = AppData.instance.profiles[profileNum].fioList.length;
    //   fioList = AppData.instance.profiles[profileNum].fioList;
    //   streamListener = AppData.instance.profiles[profileNum].updFio.listen((b) {
    //     updateState(b);
    //   });
  }

  // void updateState(bool b) {
  //   // if (mounted) {
  //   setState(() {
  //     itemCount = AppData.instance.profile.fioList.length;
  //     fioList = AppData.instance.profile.fioList;
  //   });
  //   // }
  // }

  // @override
  // void dispose() {
  //   // AppData.instance.profiles[profileNum].updFio
  //   streamListener.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Expanded(
            child: Text(
                "Люди с отделения ${AppData.instance.profiles[profileNum]
                    .name}"),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => AppData.instance.profiles[profileNum].syncFio(),
          ),
        ]),
      ),
      body: Center(
        child: Selector<AppData, List<FioEntry>>(
          selector: (_, model) => model.profiles[profileNum].fioList,
          builder: (context, fioList, _) {
            return fioList.isNotEmpty
                ? ListView.builder(
                itemCount: fioList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(fioList[index].ufio +
                        " № " +
                        fioList[index].contract),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const ListServices(fioId)),
                    //   );
                    // },
                    // subtitle: Container(width: 48, height: 48),
                  );
                })
                : const Text(
              "Список получателей СУ пуст, \n\n"
                  "попросите заведующего отделением добавить людей в ваш список обслуживаемых и \n\n"
                  "обновите список",
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}
