import 'dart:ui';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:flutter/cupertino.dart';
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

    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Expanded(
              child: Text(
                'Люди с отделения ${AppData.instance.profiles[profileNum].name}',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => AppData.instance.profiles[profileNum].syncHiveFio(),
            ),
          ]),
        ),
        body: Center(
          child: Consumer<AppData>(
            builder: (context, data, child) {
              // List<FioEntry> fioList = data.profiles[profileNum].fioList;
              final fioList = AppData.instance.profiles[profileNum].fioList;

              return
                  // Selector<AppData, List<FioEntry>>(
                  //   selector: (_, model) => model.profiles[profileNum].fioList,
                  //   builder: (context, fioList, _) {return
                  //
                  //
                  //   List<FioEntry> fioList = context.select<AppData, List<FioEntry>>(
                  //         (data) => data.profiles[profileNum].fioList,
                  // );
                  //     dev.log(fioList.toString());
                  //   dev.log(AppData().profiles[profileNum].fioList.toString());
                  fioList.isNotEmpty
                      ? ListView.builder(
                          itemCount: fioList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text('${fioList[index].ufio} № ${fioList[index].contract}'),
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const ListServices(fioId)),
                              //   );
                              // },
                              // subtitle: Container(width: 48, height: 48),
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
      ),
    );
  }
}
