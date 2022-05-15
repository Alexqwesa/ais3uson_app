import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Helper for HomeScreen, this widget: show list of [WorkerProfile].
///
/// {@category UI WorkerProfiles}
class ListOfProfiles extends ConsumerWidget {
  const ListOfProfiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wps = ref.watch(workerProfiles);

    return wps.isNotEmpty
        ? ContextMenuOverlay(
            child: ListView.builder(
              controller: ScrollController(),
              itemCount: wps.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final workerProfile = wps[index];

                return ContextMenuRegion(
                  //
                  // > context menu
                  //
                  contextMenu: GenericContextMenu(
                    buttonConfigs: [
                      ContextMenuButtonConfig(
                        S.of(context).exportThisWeek,
                        onPressed: () => ref
                            .read(journalOfWorker(workerProfile))
                            .exportToFile(
                              mostRecentMonday(),
                              mostRecentMonday(addDays: 7),
                            ),
                      ),
                      ContextMenuButtonConfig(
                        S.of(context).exportLastWeek,
                        onPressed: () => ref
                            .read(journalOfWorker(workerProfile))
                            .exportToFile(
                              mostRecentMonday(addDays: -7),
                              mostRecentMonday(),
                            ),
                      ),
                      ContextMenuButtonConfig(
                        S.of(context).exportThisMonth,
                        onPressed: () => ref
                            .read(journalOfWorker(workerProfile))
                            .exportToFile(
                              mostRecentMonth(),
                              mostRecentMonth(addMonths: 1),
                            ),
                      ),
                      ContextMenuButtonConfig(
                        S.of(context).exportLastMonth,
                        onPressed: () => ref
                            .read(journalOfWorker(workerProfile))
                            .exportToFile(
                              mostRecentMonth(addMonths: -1),
                              mostRecentMonth(),
                            ),
                      ),
                    ],
                  ),
                  //
                  // > card
                  //
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Transform.scale(
                          scale: 2,
                          child: const Icon(Icons.group),
                        ),
                      ),
                      title: Text(
                        wps[index].key.dep,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      //
                      // > onTap call
                      //
                      onTap: () {
                        ref.read(lastApiKey.notifier).state = wps[index].apiKey;
                        Navigator.pushNamed(
                          context,
                          '/department',
                        );
                      },
                      subtitle: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wps[index].name),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(wps[index].key.comment),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text(
              S.of(context).authorizePlease,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          );
  }
}