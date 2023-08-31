import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Helper for HomeScreen, this widget: show list of [Worker].
///
/// {@category UI Workers}
class ListOfDepartments extends ConsumerWidget {
  const ListOfDepartments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wps = ref.watch(workerKeysProvider).keys;

    return Center(
      child: wps.isNotEmpty
          ? ContextMenuOverlay(
              child: ListView.builder(
                itemCount: wps.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Center(
                    child: SizedBox(
                      width: 650,
                      child: ContextMenuRegion(
                        //
                        // > context menu
                        //
                        contextMenu: GenericContextMenu(
                          buttonConfigs: [
                            ContextMenuButtonConfig(
                              tr().exportThisWeek,
                              onPressed: () {
                                final worker = ref.watch(
                                    workerProvider(wps[index].apiKey).notifier);
                                worker.journalAllOf.exportToFile(
                                  mostRecentMonday(),
                                  mostRecentMonday(addDays: 7),
                                );
                              },
                            ),
                            ContextMenuButtonConfig(
                              tr().exportLastWeek,
                              onPressed: () {
                                final worker = ref.watch(
                                    workerProvider(wps[index].apiKey).notifier);
                                worker.journalAllOf.exportToFile(
                                  mostRecentMonday(addDays: -7),
                                  mostRecentMonday(),
                                );
                              },
                            ),
                            ContextMenuButtonConfig(
                              tr().exportThisMonth,
                              onPressed: () {
                                final worker = ref.watch(
                                    workerProvider(wps[index].apiKey).notifier);
                                worker.journalAllOf.exportToFile(
                                  mostRecentMonth(),
                                  mostRecentMonth(addMonths: 1),
                                );
                              },
                            ),
                            ContextMenuButtonConfig(
                              tr().exportLastMonth,
                              onPressed: () {
                                final worker = ref.watch(
                                    workerProvider(wps[index].apiKey).notifier);
                                worker.journalAllOf.exportToFile(
                                  mostRecentMonth(addMonths: -1),
                                  mostRecentMonth(),
                                );
                              },
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
                              wps[index].dep,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            //
                            // > onTap call
                            //
                            onTap: () {
                              final worker = ref.watch(
                                  workerProvider(wps[index].apiKey).notifier);
                              context.push(
                                '/department/${worker.shortName}',
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
                                    child: Text(wps[index].comment),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Text(
              tr().authorizePlease,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
    );
  }
}
