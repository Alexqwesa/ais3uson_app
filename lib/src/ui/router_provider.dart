import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/helpers/global_helpers.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router_provider.g.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _archiveNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter route(Ref ref) {
  return ref.watch(routerProvider(null));
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref, String? initialLocation) {
  // final route = ref.watch(appRouteProvider);
  // final controller = ref.watch(appRouteProvider.notifier);
  final archive = ref.watch(isArchive);

  return GoRouter(
    // navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation ?? '/',
    debugLogDiagnostics: true,
    observers: <NavigatorObserver>[
      AppRouteObserver(ref),
    ],
    redirect: (context, state) {
      Future(
        () => locator<SharedPreferences>().setString(
          AppRouteObserver.name,
          state.matchedLocation,
        ),
      );

      if (archive) {
        if (!state.matchedLocation.startsWith('/archive')) {
          final date = ref.watch(archiveDate) == null
              ? 'null'
              : standardFormat.format(ref.watch(archiveDate)!);
          final path = '/archive/$date/${state.matchedLocation.substring(1)}';
          return path;
        }
        return null;
      }
      return null; // issue https://github.com/flutter/flutter/issues/123973
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          ..._routes(ref),
          ShellRoute(
            navigatorKey: _archiveNavigatorKey,
            builder: (context, state, child) {
              return ArchiveShellRoute(child: child);
            },
            routes: [
              GoRoute(
                path: 'archive',
                builder: (context, state) => const HomeScreen(),
              ),
              // GoRoute(
              //   path: 'archive/null',
              //   builder: (context, state) => const HomeScreen(),
              // ),
              GoRoute(
                path: 'archive/:date',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  ..._routes(ref),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

List<GoRoute> _routes(Ref ref) {
  return [
    GoRoute(
      path: 'delete_department',
      builder: (context, state) => const DeleteDepartmentScreen(),
    ),
    GoRoute(
      path: 'dev',
      builder: (context, state) => const DevScreen(),
    ),
    GoRoute(
      path: 'scan_qr',
      builder: (context, state) => const QRScanScreen(),
    ),
    GoRoute(
      // name: 'department',
      path: 'department/:shortName',
      builder: (context, state) {
        final depName = state.pathParameters['shortName'];
        final wp = ref.watch(departmentsProvider.notifier)[depName];
        return ListOfClientsScreen(workerProfile: wp);
      },
      routes: [
        GoRoute(
            path: 'client/:contractId',
            builder: (context, state) {
              return ProviderScope(
                overrides: getOverrides(ref, state),
                child: const ListOfClientServicesScreen(),
              );
            },
            routes: [
              GoRoute(
                path: 'journal',
                builder: (context, state) {
                  return ProviderScope(
                    overrides: getOverrides(ref, state),
                    child: const ArchiveServicesOfClientScreen(),
                  );
                },
              ),
              GoRoute(
                path: 'service/:serviceId',
                builder: (context, state) {
                  return ProviderScope(
                    overrides: getOverrides(ref, state),
                    child: const ClientServiceScreen(),
                  );
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      path: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: 'add_department',
      builder: (context, state) => const AddDepartmentScreen(),
    ),
  ];
}

/// Create List of overrides from [GoRouterState].
///
/// Currently override:
/// - [currentClient],
/// - [currentService].
List<Override> getOverrides(Ref ref, GoRouterState state) {
  final depName = state.pathParameters['shortName'];
  final serviceId =
      int.tryParse(state.pathParameters['serviceId'] ?? '-1') ?? -1;

  final contractId =
      int.tryParse(state.pathParameters['contractId'] ?? '-1') ?? -1;

  return [
    currentService.overrideWith((ref) {
      final wp = ref.watch(departmentsProvider.notifier)[depName];
      final client = ref.watch(wp.clientsOf).firstWhere(
          (element) => element.contractId == contractId,
          orElse: () => stubClient);
      final service = ref.watch(client.servicesOf).firstWhere(
          (element) => element.servId == serviceId,
          orElse: () => stubClientService);
      return service;
    }),
    currentClient.overrideWith((ref) {
      final wp = ref.watch(departmentsProvider.notifier)[depName];
      final client = ref.watch(wp.clientsOf).firstWhere(
          (element) => element.contractId == contractId,
          orElse: () => stubClient);
      return client;
    })
  ];
}
