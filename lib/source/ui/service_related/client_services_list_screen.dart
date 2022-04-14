import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show WidgetRef, ConsumerWidget;

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UI Services}
class ClientServicesListScreen extends ConsumerWidget {
  /// Show list of services assigned to client, allow input by click.
  const ClientServicesListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastClient);
    final workerProfile = client.workerProfile;
    final servList = ref.watch(servicesOfClient(client));

    return Scaffold(
      //
      // > appBar
      //
      appBar: AppBar(
        title: Row(
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
                await workerProfile.syncPlanned();
              },
            ),
          ],
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: servList.isNotEmpty
                ? Center(
                    child: SingleChildScrollView(
                      key: const ValueKey('MainScroll'),
                      child: Wrap(
                        // children: [],
                        children: servList
                            .map(
                              (element) => ServiceCard(
                                service: element,
                                parentSize: constraints.biggest,
                              ),
                            )
                            .toList(),
                      ),
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
    );
  }
}
