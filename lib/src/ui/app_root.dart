import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

GoRouter _router(WidgetRef ref) {
  return GoRouter(
    initialLocation: '/',
    observers: <NavigatorObserver>[
      AppRouteObserver(ref),
    ],
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/delete_department',
        builder: (context, state) => const DeleteDepartmentScreen(),
      ),
      GoRoute(
        path: '/dev',
        builder: (context, state) => const DevScreen(),
      ),
      GoRoute(
        path: '/scan_qr',
        builder: (context, state) => const QRScanScreen(),
      ),
      GoRoute(
        path: '/department',
        builder: (context, state) => const ListOfClientsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/service',
        builder: (context, state) => const ClientServiceScreen(),
      ),
      GoRoute(
        path: '/client_services',
        builder: (context, state) => const ListOfClientServicesScreen(),
      ),
      GoRoute(
        path: '/add_department',
        builder: (context, state) => const AddDepartmentScreen(),
      ),
      GoRoute(
        path: '/client_journal',
        builder: (context, state) => const ArchiveServicesOfClientScreen(),
      ),
    ],
  );
}

/// Root widget of whole app.
///
/// Switch between [ArchiveMaterialApp] and [MainMaterialApp]
///
/// {@category UI Root}
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(isArchive)
        ? const ArchiveMaterialApp()
        : const MainMaterialApp();
  }
}

/// Show Archive AppBar then app in archive mode.
///
/// {@category UI Root}
class ArchiveMaterialApp extends ConsumerWidget {
  const ArchiveMaterialApp({
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
    return MaterialApp(
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ref.watch(isArchive)
            ? AppBar(
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(isArchive.notifier).state = false;
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
              )
            : null,
        body: Builder(
          builder: (context) {
            return OverflowBox(
              alignment: Alignment.bottomCenter,
              // this code is only for platforms with status bar (android)
              maxHeight: !kIsWeb && !Platform.isAndroid
                  ? null
                  : MediaQuery.of(context).size.height -
                      (ref.watch(isArchive) ? kToolbarHeight : 0),
              //
              // > main MaterialApp
              //
              child: const MainMaterialApp(),
            );
          },
        ),
      ),
    );
  }
}

/// This is main MaterialApp widget.
///
/// Only theme [standardTheme] and navigation routes here.
/// home: [HomeScreen].
///
/// {@category UI Root}
class MainMaterialApp extends ConsumerWidget {
  const MainMaterialApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: _router(ref),
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
