import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/client_profile.dart';
import 'package:ais3uson_app/src/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/src/screens/service_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FioServicesScreen extends StatefulWidget {
  late final int profileNum;

  late final int contractId;

  late final ClientProfile client;

  FioServicesScreen({Key? key}) : super(key: key) {
    profileNum = AppData().lastScreen.profileNum;
    contractId = AppData.instance.lastScreen.contractId;
    client = AppData.instance.profiles[profileNum].clients
        .firstWhere((element) => contractId == element.contractId);
  }

  @override
  _FioServicesScreenState createState() => _FioServicesScreenState();
}

class _FioServicesScreenState extends State<FioServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Expanded(
              child: Text(
                widget.client.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await AppData.instance.profiles[widget.profileNum]
                    .syncHivePlanned();
              },
            ),
          ]),
        ),
        body: Center(
          child: Consumer<AppData>(
            builder: (context, data, child) {
              final clients = context.select<AppData, List<FioPlanned>>(
                (data) => data.profiles[widget.profileNum].clients
                    .firstWhere(
                        (element) => widget.contractId == element.contractId)
                    .services,
              );
              final servList = clients
                  .where((element) => widget.contractId == element.contractId)
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
