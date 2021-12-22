import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/client_profile.dart';
import 'package:ais3uson_app/src/data_classes/client_service.dart';
import 'package:ais3uson_app/src/screens/list_services.dart';
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
    final size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<ClientProfile>.value(
      value: AppData()
          .profiles[widget.profileNum]
          .clients
          .firstWhere((element) => element.contractId == widget.contractId),
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
          child: SingleChildScrollView(
            child: Consumer<ClientProfile>(
              builder: (context, data, child) {
                final servList =
                    context.select<ClientProfile, List<ClientService>>(
                        (data) => data.services.toList());

                return ListServices(
                  width: size.width,
                  servListFio: servList,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
