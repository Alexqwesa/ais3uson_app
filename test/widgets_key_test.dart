// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/global_helpers.dart';
// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions/worker_extension.dart';
import 'helpers/fake_path_provider_platform.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    //
    // > locator
    //
    await locator.reset();
    final sharedPreferences = await SharedPreferences.getInstance();
    locator
      ..registerLazySingleton<AppLocalizations>(() => const Locale('en').tr)
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });
  group('Widget tests', () {
    testWidgets('it show list of worker profiles', (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, _) = await openRefContainer();
      // ----
      const widgetForTesting = ListOfDepartments();
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
            ref,
          ),
        ),
      );

      // await tester.runAsync<void>(() async {
      //   await wp.postInit();
      // });
      expect(wp.key.name, wKeysData2().name);
      await tester.pumpAndSettle();
      // Check
      expect(find.textContaining(tr().authorizePlease), findsNothing);
      expect(find.text(wKeysData2().name), findsOneWidget);
    });

    testWidgets('it add department', (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, _) = await openRefContainer();
      // ----
      //
      // > add department screen
      //
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            null, ref, // ?
            //
            // > routes
            //
            initialRoute: '/add_department',
          ),
        ),
      );
      await tester.pumpAndSettle();
      //
      // > add dep
      //
      final tile = find.byType(ListTile);
      expect(tile, findsOneWidget);
      await tester.tap(tile);
      //
      // > check home screen
      //
      await tester.pumpAndSettle();
      expect(ref.read(workerKeysProvider).length, 2); // wp + 1
      try {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              return ProviderScope(
                parent: ref,
                child: localizedMaterialApp(
                  const HomeScreen(),
                  ref,
                ),
              );
            },
          ),
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // developer.log(e);
      }
      // expect(wp.clients.length, 0); // this run forever
      // await tester.runAsync<void>(() async {
      //   wp.clients.length;
      //   await ref.pump();
      //   expect(wp.clients.length, 10);
      // });
      //
      // > home screen
      //
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            const HomeScreen(),
            ref,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining(tr().authorizePlease), findsNothing);
      expect(find.text(wp.key.comment), findsOneWidget);
      expect(find.text(wp.key.name), findsOneWidget);
      expect(find.text(wp.key.dep), findsNWidgets(2));
      await tester.pumpAndSettle();
      // Check
      expect(find.textContaining(tr().emptyListOfPeople), findsNothing);
    });

    testWidgets('it delete department', (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, wKey, wp, _) = await openRefContainer();
      // ----
      expect(wp.apiKey, wKey.apiKey);
      expect(ref.read(workerKeysProvider).length, 1);
      //
      // > delete department screen
      //
      await tester.pumpRealRouterApp(
          '/delete_department',
          (child) => ProviderScope(
                child: child,
                parent: ref,
              ),
          ref: ref);
      await tester.pump(const Duration(seconds: 1));
      //
      // > dep exist
      //
      expect(find.byType(DeleteDepartmentScreen), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      // await tester.pump();
      // await tester.pumpWidget(screen(UniqueKey()));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      // await tester.pumpWidget(screen(UniqueKey()));
      // await ref.pump();
      expect(ref.read(workerKeysProvider).length, 0);
    });

    testWidgets("it show list of worker's clients", (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, _) = await openRefContainer();
      // ----
      await tester.runAsync<void>(() async {
        // final wp = ref.read(workerKeysProvider).firstWorker; // ?
        // await ref.read(hiveBox(hiveHttpCache).future);
        await wp.postInit();
        // await wp.syncClients();
      });
      expect(ref.read(workerKeysProvider).firstWorker.shortName, '8717825');
      //
      // > set widget
      //
      await tester.pumpRealRouterApp(
        '/department/${ref.read(workerKeysProvider).firstWorker.shortName}',
        (child) => ProviderScope(parent: ref, child: child),
        ref: ref,
      );
      //
      // > check widget
      //
      await tester.pumpAndSettle();
      expect(find.byType(ListOfClientsScreen), findsOneWidget);
      expect(find.text(wp.clients.first.contract), findsOneWidget);
      expect(find.textContaining(tr().emptyListOfPeople), findsNothing);
    });

    testWidgets('it show list of services ', (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, _) = await openRefContainer();
      // ----
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      //
      // > set widget
      //
      final widgetForTesting = ProviderScope(overrides: [
        currentClient.overrideWithValue(
            ref.read(workerKeysProvider).firstWorker.clients.first)
      ], child: const ListOfClientServicesScreen());
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
            ref,
          ),
        ),
      );

      await tester.pumpAndSettle();
      // await tester.pump(const Duration(seconds: 1));
      // Scroll until the item to be found appears.
      // final listFinder = find.byKey(const ValueKey('MainScroll'));
      // await tester.scrollUntilVisible(
      //   itemFinder,
      //   500.0,
      //   scrollable: listFinder ,
      // );
      // Check
      expect(find.text('Покупка продуктов питания'), findsOneWidget);
      expect(
        find.textContaining(tr().noServicesForClient),
        findsNothing,
      );
    });

    testWidgets('it show empty list of services', (tester) async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, _) = await openRefContainer();
      // ----
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      // wp.clients[1].services.clear();
      expect(wp.clients[1].services.isEmpty, true);
      expect(wp.clients[0].services.isEmpty, false);
      final widgetForTesting = ProviderScope(overrides: [
        currentClient.overrideWithValue(
            ref.read(workerKeysProvider).firstWorker.clients[1])
      ], child: const ListOfClientServicesScreen());
      await tester.pumpWidget(
        ProviderScope(
          // overrides: [
          //   servicesOfClient(ref.read(currentClient)).overrideWithValue(<ClientService>[]),
          // ],
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
            ref,
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      final listFinder = find.byKey(const ValueKey('MainScroll'));
      expect(listFinder, findsNothing);
      expect(
        find.textContaining(tr().noServicesForClient),
        findsOneWidget,
      );
    });
  });
}
