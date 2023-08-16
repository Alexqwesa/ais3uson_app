import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// This is main MaterialApp widget.
///
/// Only theme [standardTheme] and navigation routes here.
/// home: [HomeScreen].
///
/// {@category UI Root}
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // onGenerateInitialRoutes: defaultGenerateInitialRoutes,

      routerConfig: ref.watch(routerProvider(null)),

      // routerDelegate: RouterDelegate(),
      //
      // > l10n
      //
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'AIS 3USON App',
      //
      // > theme
      //
      theme: ThemesData.light(),
      darkTheme: ThemesData.dark(),
      themeMode: ref.watch(standardTheme),

      debugShowCheckedModeBanner: false,
    );
  }
}

/// Show Archive AppBar then app in archive mode.
///
/// {@category UI Root}
class ArchiveMaterialApp extends ConsumerWidget {
  final Widget child;

  const ArchiveMaterialApp({
    required this.child,
    super.key,
  });

  /// Activate archive mode([isArchive]) only if [initDatesInAllArchives].dates
  /// not empty.
  ///
  /// It also show date picker to set [archiveDate].
  static Future<void> setArchiveOnWithDatePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(initDatesInAllArchives.future);
    final archiveDates =
        ref.read(initDatesInAllArchives).asData?.value ?? <DateTime>{};

    if (archiveDates.isEmpty) {
      ref.read(isArchive.notifier).state = false;

      return;
    }
    if (context.mounted) {
      ref.read(archiveDate.notifier).state = await showDatePicker(
        context: context,
        selectableDayPredicate: archiveDates.contains,
        initialDate: archiveDates.last,
        lastDate: archiveDates.last,
        firstDate: archiveDates.first,
      );
    }
    ref.read(isArchive.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(isArchive.notifier).state = false;
                context.push('/');
              },
              icon: const Icon(Icons.cancel_outlined),
            ),
            Text(
              '${tr().archiveAt} '
              // ignore: lines_longer_than_80_chars
              '${ref.watch(archiveDate) == null ? '' : standardFormat.format(ref.watch(archiveDate)!)}',
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
