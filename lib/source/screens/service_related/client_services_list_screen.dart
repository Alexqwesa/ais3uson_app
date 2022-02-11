import 'dart:async';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    final clientProfile = widget.clientProfile;
    if (clientProfile.services.isEmpty) {
      unawaited(clientProfile.updateServices());
      // unawaited( clientProfile.workerProfile.syncHivePlanned());
    }

    super.initState();
  }

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
                            children: List.of(
                              servList.map(
                                (element) {
                                  return ServiceCard(
                                    service: element,
                                    width: size.width,
                                  );
                                },
                              ),
                              // growable: false,
                            ),
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
