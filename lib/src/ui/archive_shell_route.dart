import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Show Archive AppBar then app in archive mode.
///
/// {@category UI Root}
class ArchiveShellRoute extends ConsumerWidget {
  final Widget child;

  const ArchiveShellRoute({
    required this.child,
    super.key,
  });

  /// Activate archive mode([appStateProvider].isArchive) only if [allDaysWithServicesInited].dates
  /// not empty.
  ///
  /// It also show date picker to set [appStateProvider].atDate.
  static Future<void> setArchiveOnWithDatePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(allDaysWithServicesInited.future);
    final archiveDates =
        ref.read(allDaysWithServicesInited).asData?.value ?? <DateTime>{};

    if (archiveDates.isEmpty) {
      // ref.read(isArchiveProvider.notifier).state = false;

      return;
    }
    if (context.mounted) {
      final date = await showDatePicker(
              context: context,
              selectableDayPredicate: archiveDates.contains,
              initialDate: archiveDates.last,
              lastDate: archiveDates.last,
              firstDate: archiveDates.first,
            );
      if (date != null){
        ref.watch(appStateProvider).toArchiveDate(date);
      }else{
        ref.watch(appStateProvider).toArchiveAll();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // right now we can only close by changing isArchive provider

        title: Row(
          children: [
            IconButton(
              onPressed: () {
                appState.toActive();
                context.push('/');
              },
              icon: const Icon(Icons.cancel_outlined),
            ),
            Text(
              '${tr().archiveAt} '
              '${appState.dateAsString}',
            ),
          ],
        ),
        backgroundColor: Colors.yellow[700],
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.date_range),
                // ignore: avoid-passing-async-when-sync-expected
                onPressed: () async {
                  await setArchiveOnWithDatePicker(context, ref);
                },
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }
}
