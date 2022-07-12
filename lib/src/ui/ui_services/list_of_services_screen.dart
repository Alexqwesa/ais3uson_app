import 'dart:io';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_service_card_widget.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show
        ConsumerState,
        ConsumerStatefulWidget,
        ConsumerWidget,
        ProviderScope,
        WidgetRef;
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Show list of services assigned to client, allow input by click.
///
/// Create [ServiceCard] widget for each [ClientService].
/// Support: resync button and change of view of the list.
///
/// {@category UI Services}
class ListOfClientServicesScreen extends ConsumerStatefulWidget {
  /// Show list of services assigned to client, allow input by click.
  const ListOfClientServicesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ClientServicesListScreen createState() => _ClientServicesListScreen();
}

class _ClientServicesListScreen
    extends ConsumerState<ListOfClientServicesScreen> {
  _ClientServicesListScreen() {
    searchBar = SearchBar(
      inBar: false,
      hintText: tr().search,
      setState: setState,
      controller: _textEditingController,
      onSubmitted: (value) =>
          ref.read(currentSearchText.notifier).state = value,
      onChanged: (value) => ref.read(currentSearchText.notifier).state = value,
      buildDefaultAppBar: buildAppBar,
      clearOnSubmit: false,
    );
  }

  late final SearchBar searchBar;
  final _textEditingController = TextEditingController();

  Widget buildAppBar(BuildContext context) {
    final client = ref.watch(lastUsed).client;
    final workerProfile = client.workerProfile;

    return AppBar(
      title: GestureDetector(
        onTap: () => ref.read(currentSearchText.notifier).state = '',
        child: Text(
          ref.watch(currentSearchText) != ''
              ? ' "${ref.watch(currentSearchText)}" '
              : client.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      //
      // > buttons in appBar:
      //
      actions: [
        // search
        searchBar.getSearchAction(context),
        // microphone
        if (kIsWeb || Platform.isAndroid || Platform.isIOS)
          IconButton(
            icon: const Icon(Icons.mic_none_rounded),
            //
            // > Start listening
            //
            onPressed: () async {
              await ref.watch(speechEngineInited.future);
              await ref.watch(speechEngine).listen(
                onResult: (result) {
                  ref.read(currentSearchText.notifier).state =
                      result.recognizedWords;
                  _textEditingController.text = result.recognizedWords;
                  searchBar.beginSearch(context);
                },
              );
            },
          ),
        // refresh
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async {
            await ref.read(journalOfWorker(workerProfile)).archiveOldServices();
            await ref.read(journalOfWorker(workerProfile)).commitAll();
            await workerProfile.syncPlanned();
          },
        ),
        //
        // > popup menu
        //
        const _AppBarPopupMenu(),
      ],
    );
  }

  bool inited = false;

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      inited = true;
      Future.delayed(
        // todo: fix it
        const Duration(milliseconds: 100),
        () => ref.read(currentServiceContainerSize.notifier).state =
            MediaQuery.of(context).size,
      );
    }

    final client = ref.watch(lastUsed).client;
    final servList = ref.watch(filteredServices(client));
    final speechStatus = ref.watch(speechEngineStatus);
    final searchedText = ref.watch(currentSearchText);

    return Scaffold(
      //
      // > appBar
      //
      appBar: (speechStatus != stt.SpeechToText.listeningStatus
          ? searchBar.build(context)
          //
          // > stop words recognition button, only shown on listening
          //
          : _StopListenMicAppBar(
              searchBar: searchBar,
            )) as PreferredSizeWidget,
      //
      // > body
      //
      body: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (size) {
          Future.delayed(
            const Duration(milliseconds: 100),
            () => ref
                .read(currentServiceContainerSize.notifier)
                .delayedChange(MediaQuery.of(context).size),
          );

          return true;
        },
        child: SizeChangedLayoutNotifier(
          child: Center(
            child: ref.watch(servicesOfClient(client)).isNotEmpty
                ? servList.isNotEmpty
                    ? const Center(
                        child: _ListOfServices(),
                      )
                    : Text(
                        '${tr().onRequest} $searchedText  ${tr().servicesNotFound}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      )
                : Text(
                    tr().noServicesForClient,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Stop words recognition button in AppBar, only shown on listening.
class _StopListenMicAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const _StopListenMicAppBar({
    required this.searchBar,
    Key? key,
  }) : super(key: key);

  final SearchBar searchBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speech = ref.read(speechEngine);

    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.mic_rounded),
                autofocus: true,
                onPressed: () async {
                  // searchBar.beginSearch(context);
                  await speech.stop();
                  log
                    ..fine('speech ${speech.lastStatus}')
                    ..fine('speech ${speech.lastRecognizedWords}');
                  ref.read(currentSearchText.notifier).state =
                      speech.lastRecognizedWords;
                },
              ),
              Center(
                child: Text(speech.lastRecognizedWords),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight) * 1.5;
}

class _ListOfServices extends ConsumerWidget {
  const _ListOfServices({
    Key? key,
  }) : super(key: key);

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
