import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/client_service_at.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:ais3uson_app/source/screens/settings_screen.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget, ConsumerWidget, WidgetRef;

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UI Services}
class ClientServicesListScreen extends ConsumerStatefulWidget {
  /// Show list of services assigned to client, allow input by click.
  const ClientServicesListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ClientServicesListScreen createState() => _ClientServicesListScreen();
}

class _ClientServicesListScreen
    extends ConsumerState<ClientServicesListScreen> {
  _ClientServicesListScreen() {
    searchBar = SearchBar(
      inBar: false,
      hintText: 'Поиск',
      setState: setState,
      controller: _textEditingController,
      onSubmitted: (value) {
        searchText = value;
        setState(
          () => searchText = value,
        );
      },
      onChanged: (value) {
        searchText = value;
        setState(
          () => searchText = value,
        );
      },
      buildDefaultAppBar: buildAppBar,
      clearOnSubmit: false,
    );
  }

  String searchText = '';
  late final SearchBar searchBar;
  final _textEditingController = TextEditingController();
  // void onRecognitionResult(String text) => setState(() => _textEditingController.text = text);

  Widget buildAppBar(BuildContext context) {
    final client = ref.watch(lastClient);
    final workerProfile = client.workerProfile;

    return AppBar(
      title: GestureDetector(
        onTap: () => setState(() => searchText = ''),
        child: Text(
          searchText != '' ? ' "$searchText" ' : client.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        searchBar.getSearchAction(context),

        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async {
            await ref.read(journalOfWorker(workerProfile)).archiveOldServices();
            await ref.read(journalOfWorker(workerProfile)).commitAll();
            await workerProfile.syncPlanned();
          },
        ),
        const _AppBarPopupMenu(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(lastClient);
    final search = searchText.toLowerCase();
    final servList = ref
        .watch(servicesOfClient(client))
        .where((element) => element.servText.toLowerCase().contains(search))
        .map((e) => ClientServiceAt(
              clientService: e,
              date: ref.watch(isArchive)
                  ? ref.watch(archiveDate)
                  : DateTime.now(),
            ))
        .toList(growable: false);

    return Scaffold(
      //
      // > appBar
      //
      appBar: searchBar.build(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ref.watch(servicesOfClient(client)).isNotEmpty
                ? servList.isNotEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          key: const ValueKey('MainScroll'),
                          child: Wrap(
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
                        'По запросу: ${searchText},\n\n'
                        'Услги не найдены!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
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

class _AppBarPopupMenu extends ConsumerWidget {
  const _AppBarPopupMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<dynamic>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.grid_3x3),
            title: Text(S.of(context).detailed),
            onTap: () {
              Navigator.pop(context, '');
              ref.read(tileTypeProvider.notifier).state = '';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(S.of(context).list),
            onTap: () {
              Navigator.pop(context, 'tile');
              ref.read(tileTypeProvider.notifier).state = 'tile';
            },
          ),
        ),
        PopupMenuItem<ListTile>(
          child: ListTile(
            leading: const Icon(Icons.image),
            title: Text(S.of(context).small),
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
