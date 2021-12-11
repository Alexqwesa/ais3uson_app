// ignore_for_file: avoid_types_on_closure_parameters

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/service_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfAllServices extends StatefulWidget {
  const ListOfAllServices({Key? key}) : super(key: key);

  @override
  State createState() => _ListOfAllServices();
}

class _ListOfAllServices extends State<ListOfAllServices> {
  // final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments;
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppData(),
      child: Center(
        child: Consumer<AppData>(builder: (context, data, child) {
          final servList =
              context.select<AppData, List<ServiceEntry>>(
            (appData) => appData.services.toList(),
          );
          // List<ServiceEntry> servList = AppData.instance.services;

          return Container(
            child: servList.isNotEmpty
                ? ListView.builder(
                    // physics: const BouncingScrollPhysics(
                    //     parent: AlwaysScrollableScrollPhysics()),
                    // controller: _controller,
                    itemCount: servList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(() {
                          return servList[index].shortText.isNotEmpty
                              ? servList[index].shortText
                              : servList[index].servText;
                        }()),
                        leading: () {
                          return servList[index].image.isNotEmpty
                              ? FractionallySizedBox(
                                  child: Image.asset(
                                    'images/${servList[index].image}',
                                  ),
                                  widthFactor: 0.5,
                                )
                              : const Icon(Icons.error);
                        }(),
                        //
                        //
                        //
                        // onTap: () {
                        //   Navigator.pushNamed(context, "/service",
                        //       arguments:
                        //           ScreenArguments(profile: 0, service: index));
                        // },
// subtitle: Container(width: 48, height: 48),
                      );
                    },
                  )
                : Column(
                    children: [
                      const Center(
                        child: Text('Не удалось получить список сервисов!'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          AppData.instance.syncHive();
                        },
                        child: const Text('Обновить!'),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }
}
