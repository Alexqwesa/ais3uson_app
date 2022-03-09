import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
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
  late final Future<ClientProfile?> client;

  /// Show list of services assigned to client, allow input by click.
  ClientServicesListScreen({
    ClientProfile? clientProfile,
    Key? key,
  }) : super(key: key) {
    client = clientProfile != null
        ? Future(() async => clientProfile)
        : AppData.instance.getLastClient();
  }

  @override
  _ClientServicesListScreenState createState() =>
      _ClientServicesListScreenState();
}

class _ClientServicesListScreenState extends State<ClientServicesListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Загрузка')),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          final client = snapshot.data as ClientProfile;

          final workerProfile = client.workerProfile;
          final size = MediaQuery.of(context).size;

          return Scaffold(
            //
            // > appBar
            //
            appBar: AppBar(
              title: ChangeNotifierProvider<ClientProfile>.value(
                value: client,
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<ClientProfile>(
                        builder: (context, data, child) {
                          return Text(
                            client.name,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
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
              actions: [
                PopupMenuButton<dynamic>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem<ListTile>(
                      child: ListTile(
                        leading: const Icon(Icons.grid_3x3),
                        title: Text(S.of(context).detailed),
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
                        title: Text(S.of(context).list),
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
                        title: Text(S.of(context).small),
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
                value: client,
                child: SingleChildScrollView(
                  child: Consumer<ClientProfile>(
                    builder: (context, data, child) {
                      final servList = client.services;

                      //
                      // > build list
                      //
                      return Container(
                        child: servList.isNotEmpty
                            ? Center(
                                child: Wrap(
                                  children: servList.map(
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
                            : Text(
                                'Список положенных услуг пуст, \n\n'
                                'возможно заведующий отделением уже закрыл договор\n\n'
                                'обновите список',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).emptyListOfPeople),
            ),
          );
        }
      },
    );
  }
}
