import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:ais3uson_app/src/screens/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FioServicesScreen extends StatefulWidget {
  const FioServicesScreen({Key? key}) : super(key: key);

  @override
  _FioServicesScreenState createState() => _FioServicesScreenState();
}

class _FioServicesScreenState extends State<FioServicesScreen> {
  @override
  Widget build(BuildContext context) {
    // var arguments = ModalRoute.of(context)!.settings.arguments;
    var args = AppData.instance.lastScreen;

    final profileNum = args.profileNum;
    final contractId = args.contractId;

    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Expanded(
              child: Text(
                  // 'Люди с отделения ${AppData.instance.profiles[profileNum].name}',
                  ''),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await AppData.instance.profiles[profileNum].syncHivePlanned();
              },
            ),
          ]),
        ),
        body: Center(
          child: Consumer<AppData>(
            builder: (context, data, child) {
              final fioPlanned =
                  AppData.instance.profiles[profileNum].fioPlanned;
              final servList = fioPlanned
                  .where((element) => element.contractId == contractId)
                  .toList(growable: true);

              return servList.isNotEmpty
                  // ?DraggableScrollableSheet(
                  //         child:

                  ? Wrap(
                      children: List.generate(
                        servList.length,
                        (index) {
                          return ServiceCard(
                            key: ValueKey(servList[index].servId),
                            service: AppData().services.firstWhere((element) =>
                                element.id == servList[index].servId),
                          );
                        },
                      ),
                    )
                  : const Text(
                      'Список положенных услуг пуст, \n\n'
                      'возможно заведующий отделением уже закрыл договор\n\n'
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
