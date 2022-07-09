import 'dart:io';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_service/client_service.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/ui/service_related/list_of_services_screen_provider_helper.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card_widget/service_card.dart';
import 'package:ais3uson_app/source/ui/settings_screen.dart';
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
      hintText: 'Поиск',
      setState: setState,
      controller: _textEditingController,
      onSubmitted: (value) =>
          setState(() => ref.read(currentSearch.notifier).state = value),
      onChanged: (value) =>
          setState(() => ref.read(currentSearch.notifier).state = value),
      buildDefaultAppBar: buildAppBar,
      clearOnSubmit: false,
    );
  }

  late final SearchBar searchBar;
  final _textEditingController = TextEditingController();
  final speech = stt.SpeechToText();

  Widget buildAppBar(BuildContext context) {
    final client = ref.watch(lastUsed).client;
    final workerProfile = client.workerProfile;

    return speech.lastStatus != stt.SpeechToText.listeningStatus
        //
        // > default appBar
        //
        ? AppBar(
            title: GestureDetector(
              onTap: () => ref.read(currentSearch.notifier).state = '',
              child: Text(
                ref.watch(currentSearch) != ''
                    ? ' "${ref.watch(currentSearch)}" '
                    : client.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //
            // > buttons in appBar
            //
            actions: [
              // search
              searchBar.getSearchAction(context),
              // microphone
              if (kIsWeb || Platform.isAndroid || Platform.isIOS)
                IconButton(
                  icon: const Icon(Icons.mic_none_rounded),
                  onPressed: startSpeechRecognition,
                ),
              // refresh
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await ref
                      .read(journalOfWorker(workerProfile))
                      .archiveOldServices();
                  await ref.read(journalOfWorker(workerProfile)).commitAll();
                  await workerProfile.syncPlanned();
                },
              ),
              //
              // > popup menu
              //
              const _AppBarPopupMenu(),
            ],
          )
        //
        // > stop words recognition button, only shown on listening
        //
        : _StopListenMicAppBar(
            speech: speech,
            searchBar: searchBar,
          );
  }

  bool inited = false;

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      inited = true;
      // ignore: invalid_use_of_protected_member
      ref.read(currentServiceContainerSize.notifier).state =
          MediaQuery.of(context).size;
    }

    final client = ref.watch(lastUsed).client;
    final servList = ref.watch(filteredServices(client));

    return Scaffold(
      //
      // > appBar
      //
      appBar: searchBar.build(context),
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
                        '${tr().onRequest} ${ref.watch(currentSearch)} ${tr().servicesNotFound}',
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

  Future<void> startSpeechRecognition() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final available = await speech.initialize(
        onStatus: (status) {
          log.fine('Speech status $status');
        },
        onError: (error) {
          log.severe('Speech error $error');
        },
      );
      if (available) {
        await speech.listen(
          onResult: (result) => setState(
            () {
              _textEditingController.text = result.recognizedWords;
              searchBar.beginSearch(context);
            },
          ),
        );
        setState(() {
          log.fine('speech ${speech.lastStatus}');
        });
        log.fine('speech ${speech.lastStatus}');
      } else {
        log.warning('The user has denied the use of speech recognition.');
      }
    }
  }
}

/// Stop words recognition button in AppBar, only shown on listening.
class _StopListenMicAppBar extends ConsumerWidget {
  const _StopListenMicAppBar({
    required this.speech,
    required this.searchBar,
    Key? key,
  }) : super(key: key);

  final stt.SpeechToText speech;
  final SearchBar searchBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: ElevatedButton(
        child: const Icon(Icons.mic_rounded),
        autofocus: true,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () async {
          searchBar.beginSearch(context);
          await speech.stop();
          log
            ..fine('speech ${speech.lastStatus}')
            ..fine('speech ${speech.lastRecognizedWords}');
          ref.read(currentSearch.notifier).state = speech.lastRecognizedWords;
        },
      ),
    );
  }
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
