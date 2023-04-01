import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_service_card_widget.dart';
import 'package:ais3uson_app/ui_services.dart';
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
    final service = ref.watch(currentService);
    final tileView = ref.watch(tileType);
    // ignore: no_leading_underscores_for_local_identifiers
    final _ = ref.watch(archiveDate); // in case of date change
    final activeViewOfCard =
        ref.watch(addAllowedOfService(service)) || ref.watch(isArchive);
    final size = ref.watch(tileSize(Tuple2(parentSize, tileView)));

    return AnimatedSize(
      // todo: don't show border during animation
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: SizedBox.fromSize(
        size: size,
        child: Stack(
          children: [
            if (!activeViewOfCard)
              const ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.multiply,
                ),
                child: _ServiceCardViewSelector(),
              ),
            if (activeViewOfCard) const _ServiceCardViewSelector(),
            //
            // InkWell animation and handler
            //
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => service.add,
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
    final tileView = ref.watch(tileType);

    return ClipRect(
      child: Row(
        children: [
          //
          // > select view
          //
          if (tileView == '')
            const ServiceCardView()
          else if (tileView == 'tile')
            const ServiceCardTileView()
          else if (tileView == 'square')
            const ServiceCardSquareView(),
        ],
      ),
    );
  }
}
