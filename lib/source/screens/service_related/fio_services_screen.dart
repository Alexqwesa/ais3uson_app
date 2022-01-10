import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/list_services.dart';
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
    final workerProfile = AppData().profiles[widget.profileNum];
    final clientProfile = AppData()
        .profiles[widget.profileNum]
        .clients
        .firstWhere((element) => element.contractId == widget.contractId);

    return ChangeNotifierProvider<ClientProfile>.value(
      value: clientProfile,
      child: Scaffold(
        //
        // > appBar
        //
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.client.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await workerProfile.journal.archiveOldServices();
                  await workerProfile.journal.commitAll();
                  await workerProfile.syncHivePlanned();
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Consumer<ClientProfile>(
              builder: (context, data, child) {
                // 
                // > get data 
                // 
                final servList =
                    context.select<ClientProfile, List<ClientService>>(
                  (data) => data.services.toList(),
                );

                // 
                // > build list 
                // 
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
