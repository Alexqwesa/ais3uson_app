import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _archiveNavigatorKey = GlobalKey<NavigatorState>();

final routeInformationProvider =
    ChangeNotifierProvider<GoRouteInformationProvider>((ref) {
  return ref.watch(routerProvider(null)).routeInformationProvider;
});

final currentRouteProvider = Provider((ref) {
  final location = ref.watch(routeInformationProvider).value.location;

  // ref.watch(appRouteProvider.notifier).state = location ?? '/';
  // ref.watch(appRouteProvider);

  return location;
});

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
      if (archive) {
        return '/archive${state.matchedLocation.replaceFirst('/archive', '')}';
      }
      return null; // issue https://github.com/flutter/flutter/issues/123973
    },
    routes: [
      ..._routes(ref),
      ShellRoute(
        navigatorKey: _archiveNavigatorKey,
        builder: (context, state, child) {
          return ArchiveMaterialApp(child: child);
        },
        routes: _routes(ref, prefix: '/archive'),
      ),
    ],
  );
}

List<GoRoute> _routes(Ref ref, {prefix = ''}) {
  return [
    GoRoute(
      path: prefix != '' ? '$prefix' : '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '$prefix/delete_department',
      builder: (context, state) => const DeleteDepartmentScreen(),
    ),
    GoRoute(
      path: '$prefix/dev',
      builder: (context, state) => const DevScreen(),
    ),
    GoRoute(
      path: '$prefix/scan_qr',
      builder: (context, state) => const QRScanScreen(),
    ),
    GoRoute(
      // name: '$prefix/department',
      path: '$prefix/department/:shortName',
      builder: (context, state) {
        final depName = state.pathParameters['shortName'];
        final wp = ref.watch(departmentsProvider.notifier)[depName];
        return ListOfClientsScreen(workerProfile: wp);
      },
      routes: [
        GoRoute(
            path: 'client/:contractId',
            builder: (context, state) {
              final depName = state.pathParameters['shortName'];
              final contractId =
                  int.tryParse(state.pathParameters['contractId'] ?? '0') ?? 0;
              final wp = ref.watch(departmentsProvider.notifier)[depName];
              final client = ref
                  .watch(wp.clientsOf)
                  .firstWhere((element) => element.contractId == contractId);
              return ProviderScope(
                overrides: [currentClient.overrideWithValue(client)],
                child: const ListOfClientServicesScreen(),
              );
            },
            routes: [
              GoRoute(
                path: 'journal',
                builder: (context, state) {
                  final depName = state.pathParameters['shortName'];
                  final contractId =
                      int.tryParse(state.pathParameters['contractId'] ?? '0') ??
                          0;
                  final wp = ref.watch(departmentsProvider.notifier)[depName];
                  final client = ref.watch(wp.clientsOf).firstWhere(
                      (element) => element.contractId == contractId);
                  return ProviderScope(
                    overrides: [currentClient.overrideWithValue(client)],
                    child: const ArchiveServicesOfClientScreen(),
                  );
                },
              ),
              GoRoute(
                path: 'service/:serviceId',
                builder: (context, state) {
                  final depName = state.pathParameters['shortName'];
                  final contractId =
                      int.tryParse(state.pathParameters['contractId'] ?? '0') ??
                          0;
                  final serviceId =
                      int.tryParse(state.pathParameters['serviceId'] ?? '0') ??
                          0;
                  final wp = ref.watch(departmentsProvider.notifier)[depName];
                  final client = ref.watch(wp.clientsOf).firstWhere(
                      (element) => element.contractId == contractId);
                  final service = ref
                      .watch(client.servicesOf)
                      .firstWhere((element) => element.servId == serviceId);
                  return ProviderScope(
                    overrides: [currentService.overrideWithValue(service)],
                    child: const ClientServiceScreen(),
                  );
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      path: '$prefix/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '$prefix/add_department',
      builder: (context, state) => const AddDepartmentScreen(),
    ),
  ];
}
