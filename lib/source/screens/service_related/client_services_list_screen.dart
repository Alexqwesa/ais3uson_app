import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/providers/app_state.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show WidgetRef, ConsumerWidget;
import 'package:provider/provider.dart';

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UIServices}
class ClientServicesListScreen extends ConsumerWidget {
  /// Show list of services assigned to client, allow input by click.
  const ClientServicesListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastClient);
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
                child: Text(
                  client.name,
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
                    ref.read(serviceViewProvider.notifier).state = '';
                  },
                ),
              ),
              PopupMenuItem<ListTile>(
                child: ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: Text(S.of(context).list),
                  onTap: () {
                    Navigator.pop(context, 'tile');
                    ref.read(serviceViewProvider.notifier).state = 'tile';
                  },
                ),
              ),
              PopupMenuItem<ListTile>(
                child: ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(S.of(context).small),
                  onTap: () {
                    Navigator.pop(context, 'square');
                    ref.read(serviceViewProvider.notifier).state = 'square';
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
  }
}
