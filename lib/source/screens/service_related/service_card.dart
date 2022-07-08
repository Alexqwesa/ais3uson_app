import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen_provider_helper.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:tuple/tuple.dart';

/// Displays one [ClientService].
///
/// This widget check is service enabled.
/// And decide which View to use:
/// [ServiceCardView], [ServiceCardTileView], [ServiceCardSquareView]
///
/// {@category UI Services}
class ServiceCard extends ConsumerWidget {
  const ServiceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentSize = ref.watch(currentServiceContainerSize);
    final service = ref.watch(currentService)!; // as ClientServiceAt;
    final tileType = ref.watch(tileTypeProvider);
    // ignore: no_leading_underscores_for_local_identifiers
    final _ = ref.watch(
      groupsOfService(service.clientService),
    ); // in case of date change
    final active = service.addAllowed || ref.watch(isArchive);
    final size = ref.watch(serviceCardSize(Tuple2(parentSize, tileType)));

    return AnimatedSize(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: SizedBox.fromSize(
        size: size,
        child: Stack(
          children: [
            if (!active)
              const ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.multiply,
                ),
                child: _ServiceCardViewSelector(),
              ),
            if (active) const _ServiceCardViewSelector(),
            //
            // InkWell animation and handler
            //
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: service.add,
                onLongPress: () {
                  // set last service
                  ref.read(lastUsed).serviceAt = service;
                  // open ClientServiceScreen
                  Navigator.pushNamed(context, '/service');
                },
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCardViewSelector extends ConsumerWidget {
  const _ServiceCardViewSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileType = ref.watch(tileTypeProvider);

    return ClipRect(
      child: Row(
        children: [
          //
          // > select view
          //
          if (tileType == '')
            const ServiceCardView()
          else if (tileType == 'tile')
            const ServiceCardTileView()
          else if (tileType == 'square')
            const ServiceCardSquareView(),
        ],
      ),
    );
  }
}
