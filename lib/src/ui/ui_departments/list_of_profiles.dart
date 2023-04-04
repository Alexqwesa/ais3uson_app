import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
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

    return Center(
      child: wps.isNotEmpty
          ? ContextMenuOverlay(
              child: ListView.builder(
                itemCount: wps.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final workerProfile = wps[index];

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
                              onPressed: () => ref
                                  .read(workerProfile.journalAllOf)
                                  .exportToFile(
                                    mostRecentMonday(),
                                    mostRecentMonday(addDays: 7),
                                  ),
                            ),
                            ContextMenuButtonConfig(
                              tr().exportLastWeek,
                              onPressed: () => ref
                                  .read(workerProfile.journalAllOf)
                                  .exportToFile(
                                    mostRecentMonday(addDays: -7),
                                    mostRecentMonday(),
                                  ),
                            ),
                            ContextMenuButtonConfig(
                              tr().exportThisMonth,
                              onPressed: () => ref
                                  .read(workerProfile.journalAllOf)
                                  .exportToFile(
                                    mostRecentMonth(),
                                    mostRecentMonth(addMonths: 1),
                                  ),
                            ),
                            ContextMenuButtonConfig(
                              tr().exportLastMonth,
                              onPressed: () => ref
                                  .read(workerProfile.journalAllOf)
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
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            //
                            // > onTap call
                            //
                            onTap: () {
                              ref.read(lastUsed).worker = wps[index];
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
