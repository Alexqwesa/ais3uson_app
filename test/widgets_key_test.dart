// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/basic_providers.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_http_data.dart';
import 'package:ais3uson_app/source/screens/department_related/add_department_screen.dart';
import 'package:ais3uson_app/source/screens/department_related/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/department_related/list_clients_screen.dart';
import 'package:ais3uson_app/source/screens/department_related/list_profiles.dart';
import 'package:ais3uson_app/source/screens/department_related/qr_scan_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/all_services_of_client.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen_provider_helper.dart';
import 'package:ais3uson_app/source/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_models_test.dart';
import 'helpers/mock_server.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });
  group('Widget tests', () {
    testWidgets('it show list of worker profiles', (tester) async {
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      const widgetForTesting = ListOfProfiles();
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
          ),
        ),
      );
      // Add Profile
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      expect(wp.key.name, wKeysData2().name);
      await tester.pumpAndSettle();
      // Check
      expect(find.textContaining(tr().authorizePlease), findsNothing);
      expect(find.text(wKeysData2().name), findsOneWidget);
    });

    testWidgets('it add department', (tester) async {
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );

      //
      // > add department screen
      //
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            const AddDepartmentScreen(),
            //
            // > routes
            //
            initialRoute: '/add_department',
            routes: {
              '/client_journal': (context) => const AllServicesOfClientScreen(),
              '/add_department': (context) => const AddDepartmentScreen(),
              '/client_services': (context) => const ClientServicesListScreen(),
              '/settings': /*    */ (context) => const SettingsScreen(),
              '/department': /*  */ (context) => const ClientScreen(),
              '/scan_qr': /*     */ (context) => const QRScanScreen(),
              '/dev': /*         */ (context) => const DevScreen(),
              '/delete_department': (context) => const DeleteDepartmentScreen(),
              '/': /*            */ (context) => const HomeScreen(),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      //
      // > add dep
      //
      expect(find.byType(ListTile), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      //
      // > check home screen
      //
      await tester.pumpAndSettle();
      expect(ref.read(workerProfiles).length, 1);
      final wp = ref.read(workerProfiles).first;
      try {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              return ProviderScope(
                parent: ref,
                child: localizedMaterialApp(
                  const HomeScreen(),
                ),
              );
            },
          ),
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // developer.log(e);
      }

      await tester.runAsync<void>(() async {
        wp.clients.length;
      });
      expect(
        wp.clients.length,
        0,
      );
      // await tester.runAsync<void>(() async {
      //   await wp.postInit();
      // });
      //
      // > home screen
      //
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            const HomeScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.textContaining(tr().authorizePlease), findsNothing);
      expect(find.text(wp.key.comment), findsOneWidget);
      expect(find.text(wp.key.name), findsOneWidget);
      expect(find.text(wp.key.dep), findsOneWidget);
      ref.read(lastUsed).worker = wp;
      await tester.pumpAndSettle();
      // Check
      expect(
        find.textContaining(tr().emptyListOfPeople),
        findsNothing,
      );
    });

    testWidgets('it delete department', (tester) async {
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      expect(wp.apiKey, wKey.apiKey);
      //
      // > delete department screen
      //
      Widget screen(Key uniqueKey) {
        return ProviderScope(
          key: uniqueKey,
          parent: ref,
          child: localizedMaterialApp(
            const DeleteDepartmentScreen(),
            //
            // > routes
            //
            initialRoute: '/add_department',
            routes: {
              '/client_journal': (context) => const AllServicesOfClientScreen(),
              '/add_department': (context) => const AddDepartmentScreen(),
              '/client_services': (context) => const ClientServicesListScreen(),
              '/settings': /*    */ (context) => const SettingsScreen(),
              '/department': /*  */ (context) => const ClientScreen(),
              '/scan_qr': /*     */ (context) => const QRScanScreen(),
              '/dev': /*         */ (context) => const DevScreen(),
              '/delete_department': (context) => const DeleteDepartmentScreen(),
              '/': /*            */ (context) => const HomeScreen(),
            },
          ),
        );
      }

      await tester.pumpWidget(screen(UniqueKey()));
      await tester.pump();
      //
      // > dep exist
      //
      expect(find.byType(ListTile), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      await tester.pump();
      await tester.pumpWidget(screen(UniqueKey()));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pumpWidget(screen(UniqueKey()));
      await ref.pump();
      // expect(ref.read(workerProfiles).length, 0); // todo
    });

    testWidgets("it show list of worker's clients", (tester) async {
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      const widgetForTesting = ClientScreen();
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
          ),
        ),
      );
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      // ref.read(workerKeys.notifier).addKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await tester.runAsync<void>(() async {
        await wp.postInit();
        await ref.read(hiveBox(hiveProfiles).future);
        await wp.syncClients();
      });
      ref.read(lastUsed).worker = wp;
      await tester.pumpAndSettle();
      // Check
      expect(
        find.text(wp.clients.first.contract),
        findsOneWidget,
      );
      expect(
        find.textContaining(tr().emptyListOfPeople),
        findsNothing,
      );
    });

    testWidgets('it show list of services ', (tester) async {
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      const widgetForTesting = ClientServicesListScreen();
      await tester.pumpWidget(
        ProviderScope(
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
          ),
        ),
      );
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      ref.read(lastUsed).worker = wp;
      ref.read(lastUsed).client = wp.clients.first;
      await tester.pumpAndSettle();
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
      final wKey = wKeysData2();
      final ref = ProviderContainer(
        overrides: [
          httpClientProvider(wKey.certificate)
              .overrideWithValue(getMockHttpClient()),
        ],
      );
      ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
      final wp = ref.read(workerProfiles).first;
      await tester.runAsync<void>(() async {
        await wp.postInit();
      });
      ref.read(lastUsed).client = wp.clients[1];
      // wp.clients[1].services.clear();
      expect(wp.clients[1].services.isEmpty, false);
      const widgetForTesting = ClientServicesListScreen();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filteredServices.overrideWithProvider(
              (argument) => Provider((ref) => <ClientService>[]),
            ),
          ],
          parent: ref,
          child: localizedMaterialApp(
            widgetForTesting,
          ),
        ),
      );
      expect(wp.clients[1].services.isEmpty, false);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      final listFinder = find.byKey(const ValueKey('MainScroll'));
      expect(listFinder, findsNothing);
      expect(
        find.textContaining(tr().servicesNotFound),
        findsOneWidget,
      );
    });
  });
}
