import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays one [ClientService].
///
/// This widget check is service enabled.
/// And decide which View to use:
/// [ServiceCardView], [ServiceCardTileView], [ServiceCardSquareView]
///
/// {@category UI Services}
class ServiceCard extends ConsumerWidget {
  const ServiceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(currentService);
    // ignore: no_leading_underscores_for_local_identifiers
    final _ = ref.watch(archiveDate); // in case of date change
    final activeViewOfCard =
        ref.watch(service.addAllowedOf) || ref.watch(isArchiveProvider);

    final cardView = switch (ref.watch(tileTypeProvider)) {
      'tile' => const ServiceCardTileView(),
      'square' => const ServiceCardSquareView(),
      _ => const ServiceCardView(),
    };

    return AnimatedSize(
      // todo: don't show border during animation
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Stack(
        children: [
          if (!activeViewOfCard)
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.multiply,
              ),
              child: SizedBox.expand(child: cardView),
            ),
          if (activeViewOfCard) SizedBox.expand(child: cardView),
          //
          // InkWell animation and handler
          //
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: service.add,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
