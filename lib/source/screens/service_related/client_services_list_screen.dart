import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UIServices}
class ClientServicesListScreen extends StatefulWidget {
  late final int profileNum;

  late final int contractId;

  late final ClientProfile client;

  late final ClientProfile clientProfile;

  late final WorkerProfile workerProfile;

  /// Show list of services assigned to client, allow input by click.
  ClientServicesListScreen({Key? key}) : super(key: key) {
    profileNum = AppData().lastScreen.profileNum;
    contractId = AppData.instance.lastScreen.contractId;
    client = AppData.instance.profiles[profileNum].clients
        .firstWhere((element) => contractId == element.contractId);
    workerProfile = AppData().profiles[profileNum];
    clientProfile = AppData()
        .profiles[profileNum]
        .clients
        .firstWhere((element) => element.contractId == contractId);
  }

  @override
  _ClientServicesListScreenState createState() =>
      _ClientServicesListScreenState();
}

class _ClientServicesListScreenState extends State<ClientServicesListScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      //
      // > appBar
      //
      appBar: AppBar(
        title: ChangeNotifierProvider<ClientProfile>.value(
          value: widget.clientProfile,
          child: Row(
            children: [
              Expanded(
                child: Consumer<ClientProfile>(
                  builder: (context, data, child) {
                    return Text(
                      widget.client.name,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await widget.workerProfile.journal.archiveOldServices();
                  await widget.workerProfile.journal.commitAll();
                  await widget.workerProfile.syncHivePlanned();
                },
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem<ListTile>(
                child: ListTile(
                  leading: const Icon(Icons.grid_3x3),
                  title: const Text('Подбробно'),
                  onTap: () {
                    Navigator.pop(context, '');
                    setState(() {
                      AppData.instance.serviceView = '';
                    });
                  },
                ),
              ),
              PopupMenuItem<ListTile>(
                child: ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('Список'),
                  onTap: () {
                    Navigator.pop(context, 'tile');
                    setState(() {
                      AppData.instance.serviceView = 'tile';
                    });
                  },
                ),
              ),
              PopupMenuItem<ListTile>(
                child: ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Значки'),
                  onTap: () {
                    Navigator.pop(context, 'square');
                    setState(() {
                      AppData.instance.serviceView = 'square';
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ChangeNotifierProvider<ClientProfile>.value(
          value: widget.clientProfile,
          child: SingleChildScrollView(
            child: Consumer<ClientProfile>(
              builder: (context, data, child) {
                final servList = widget.clientProfile.services;
                //
                // > build list
                //

                return Container(
                  child: servList.isNotEmpty
                      ? Center(
                          child: Wrap(
                            children:
                              servList.map(
                                (element) {
                                  return ServiceCard(
                                    service: element,
                                    parentSize: size,
                                  );
                                },
                              // growable: false,
                            ).toList(),
                          ),
                        )
                      : const Text(
                          'Список положенных услуг пуст, \n\n'
                          'возможно заведующий отделением уже закрыл договор\n\n'
                          'обновите список',
                          textAlign: TextAlign.center,
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
