import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../sync/fio_entry.dart';

import '../global.dart';

class ListFio extends StatefulWidget {
  const ListFio({Key? key, required this.profileNum}) : super(key: key);

  final int profileNum;

  @override
  _ListFioState createState() => _ListFioState(profileNum);
}

class _ListFioState extends State<ListFio> {
  List<FioEntry> fioList = [];

  int itemCount = 0;
  final int profileNum;
  late StreamSubscription streamListener;

  _ListFioState(this.profileNum) {
    itemCount = AppData.instance.profiles[profileNum].fioList.length;
    fioList = AppData.instance.profiles[profileNum].fioList;
    streamListener = AppData.instance.profiles[profileNum].updFio.listen((b) {
      updateState(b);
    });
  }

  void updateState(bool b) {
    // if (mounted) {
    setState(() {
      itemCount = AppData.instance.profile.fioList.length;
      fioList = AppData.instance.profile.fioList;
    });
    // }
  }

  @override
  void dispose() {
    // AppData.instance.profiles[profileNum].updFio
    streamListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Expanded(
            child: Text(
                "Люди с отделения ${AppData.instance.profiles[profileNum].name}"),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => AppData.instance.profiles[profileNum].syncfio(),
          ),
        ]),
      ),
      body: Center(
          child: itemCount > 0
              ? ListView.builder(
                  itemCount: itemCount,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(
                          fioList[index].ufio + " №" + fioList[index].contract),
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
                )),
    );
  }
}
