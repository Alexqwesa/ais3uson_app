import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show
        ConsumerState,
        ConsumerStatefulWidget,
        ConsumerWidget,
        ProviderScope,
        WidgetRef;

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UI Services}
class ListOfClientServicesScreen extends ConsumerStatefulWidget {
  /// Show list of services assigned to client, allow input by click.
  const ListOfClientServicesScreen({
    super.key,
  });

  @override
  ConsumerState<ListOfClientServicesScreen> createState() =>
      _ClientServicesListScreen();
}

class _ClientServicesListScreen
    extends ConsumerState<ListOfClientServicesScreen> {
  _ClientServicesListScreen();

  bool inited = false;

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      inited = true;
      Future.delayed(
        // todo: fix it
        const Duration(milliseconds: 100),
        () => ref.read(currentSizeOfParentForListOfServices.notifier).state =
            MediaQuery.of(context).size,
      );
    }

    final client = ref.watch(lastUsed).client;
    final servList = ref.watch(filteredServices(client));
    final searchedText = ref.watch(currentSearchText);
    final workerProfile = client.workerProfile;

    return Scaffold(
      //
      // > appBar
      //
      appBar: AppBarWithSearchSwitch(
        appBarBuilder: (context) {
          return AppBar(
            title: Text(
              client.name,
              overflow: TextOverflow.ellipsis,
            ),
            //
            // > buttons in appBar:
            //
            actions: [
              // search
              const AppBarSpeechButton(),
              // microphone
              const AppBarSearchButton(),
              // refresh
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await ref.read(workerProfile.journalOf).archiveOldServices();
                  await ref.read(workerProfile.journalOf).commitAll();
                  await workerProfile.syncPlanned();
                },
              ),
              //
              // > popup menu
              //
              const _AppBarPopupMenu(),
            ],
          );
        },
        onChanged: (text) => ref.read(currentSearchText.notifier).state = text,
      ),

      //
      // > body
      //
      body: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (size) {
          Future.delayed(
            const Duration(milliseconds: 100),
            () => ref
                .read(currentSizeOfParentForListOfServices.notifier)
                .delayedChange(MediaQuery.of(context).size),
          );

          return true;
        },
        child: SizeChangedLayoutNotifier(
          child: Center(
            child: ref.watch(client.servicesOf).isNotEmpty
                ? servList.isNotEmpty
                    ? const Center(
                        child: _ListOfServices(),
                      )
                    : Text(
                        '${tr().onRequest} $searchedText  ${tr().servicesNotFound}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                : Text(
                    tr().noServicesForClient,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ListOfServices extends ConsumerWidget {
  const _ListOfServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(lastUsed).client;
    final servList = ref.watch(filteredServices(client));

    return SingleChildScrollView(
      key: const ValueKey('MainScroll'),
      child: Wrap(
        children: servList
            .map(
              (element) => InkWell(
                child: ProviderScope(
                  overrides: [
                    currentService.overrideWithValue(element),
                  ],
                  child: const ServiceCard(
                      // key: ObjectKey(element),
                      ),
                ),
                onLongPress: () {
                  // set last service
                  ref.read(lastUsed).service = element;
                  // open ClientServiceScreen
                  Navigator.pushNamed(context, '/service');
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AppBarPopupMenu extends ConsumerWidget {
  const _AppBarPopupMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<dynamic>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.grid_3x3),
            title: Text(tr().detailed),
            onTap: () {
              Navigator.pop(context, '');
              ref.read(tileType.notifier).state = '';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(tr().list),
            onTap: () {
              Navigator.pop(context, 'tile');
              ref.read(tileType.notifier).state = 'tile';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.image),
            title: Text(tr().small),
            onTap: () {
              Navigator.pop(context, 'square');
              ref.read(tileType.notifier).state = 'square';
            },
          ),
        ),
        const PopupMenuItem<SettingServiceSizeWidget>(
          child: SettingServiceSizeWidget(),
        ),
      ],
    );
  }
}
