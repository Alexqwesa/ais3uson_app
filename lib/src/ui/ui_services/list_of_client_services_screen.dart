// ignore_for_file: avoid_catches_without_on_clauses

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tuple/tuple.dart';

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: sync button and change of view of the list.
///
/// {@category UI Services}
class ListOfClientServicesScreen extends ConsumerWidget {
  /// Show list of services assigned to client, allow input by click.

  static late final ValueNotifier<String> _textNotifier;

  ValueNotifier<String> get textNotifier {
    try {
      return _textNotifier;
    } catch (e) {
      //on LateError  LateInitializationError
      _textNotifier = ValueNotifier<String>('');
      return _textNotifier;
    }
  }

  static late final TextEditingController _textController;

  TextEditingController get textController {
    try {
      return _textController;
    } catch (e) {
      _textController = TextEditingController();
      return _textController;
    }
  }

  const ListOfClientServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(currentClient);
    final workerProfile = client.workerProfile;

    return Scaffold(
      //
      // > appBar
      //
      appBar: AppBarWithSearchSwitch(
        animation: AppBarAnimationSlideLeft.call,
        customTextNotifier: textNotifier,
        customTextEditingController: textController,
        // customSubmitNotifier: ValueNotifier<String>(''),
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
                  await workerProfile.journalOf.archiveOldServices();
                  await workerProfile.journalOf.commitAll();
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
      ),

      //
      // > body
      //
      body: Center(
        child: switch (ref.watch(client.servicesOf).isNotEmpty) {
          true => CustomScrollView(
              slivers: [
                _ListOfServices(textNotifier),
              ],
            ),
          false => Text(
              tr().noServicesForClient,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        },
      ),
    );
  }
}

class _ListOfServices extends ConsumerWidget {
  final ValueNotifier<String> textNotifier;

  const _ListOfServices(this.textNotifier);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(currentClient);

    final parentSize = MediaQuery.of(context).size;
    final tileView = ref.watch(tileTypeProvider);
    final size = ref.watch(tileSize(Tuple2(parentSize, tileView)));

    return (context) {
      return ValueListenableBuilder(
        valueListenable: textNotifier, // search text in AppBar
        builder: (context, search, child) {
          List<ClientService> servList;
          if (search.isEmpty) {
            servList = ref.watch(client.servicesOf);
          } else {
            servList = ref
                .watch(client.servicesOf)
                .where((element) =>
                    element.servText.toLowerCase().contains(search))
                .toList();
          }

          if (servList.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Text(
                  '${tr().onRequest} $search ${tr().servicesNotFound}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            );
          }

          return SliverAnimatedGrid(
            key: const ValueKey('MainScroll'),
            initialItemCount: ref
                .watch(client.servicesOf)
                .length, // why not just servList.length,
            itemBuilder: (context, index, animation) {
              if (index >= servList.length) {
                return const SizedBox();
              }

              final service = servList[index];

              return InkWell(
                key: ValueKey(service.servId),
                child: ProviderScope(
                  overrides: [
                    currentService.overrideWithValue(service),
                  ],
                  child: const ServiceCard(
                      // key: ObjectKey(element),
                      ),
                ),
                onLongPress: () {
                  // open ClientServiceScreen
                  context.push(
                    '/department/${service.workerProfile.shortName}/client/${service.contractId}/service/${service.servId}',
                  );
                },
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: parentSize.width ~/ size.width,
              childAspectRatio: size.width / size.height,
            ),
          );
        },
      );
    }(context);
  }
}

class _AppBarPopupMenu extends ConsumerWidget {
  const _AppBarPopupMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<dynamic>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.grid_3x3),
            title: Text(tr().detailed),
            onTap: () {
              Navigator.pop(context, '');
              ref.read(tileTypeProvider.notifier).state = '';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(tr().list),
            onTap: () {
              Navigator.pop(context, 'tile');
              ref.read(tileTypeProvider.notifier).state = 'tile';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.image),
            title: Text(tr().small),
            onTap: () {
              Navigator.pop(context, 'square');
              ref.read(tileTypeProvider.notifier).state = 'square';
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
