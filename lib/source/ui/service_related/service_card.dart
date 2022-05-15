import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/client_service_at.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

/// Displays one [ClientService].
///
/// This widget check is service enabled.
/// And decide which View to use:
/// [ServiceCardView], [ServiceCardTileView], [ServiceCardSquareView]
///
/// {@category UI Services}
class ServiceCard extends ConsumerWidget {
  const ServiceCard({
    required this.service,
    required this.parentSize,
    Key? key,
  }) : super(key: key);

  final ClientServiceAt service;
  final Size parentSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceView = ref.watch(serviceViewProvider);

    return SizedBox.fromSize(
      size: serviceCardSize(parentSize, serviceView),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              service.addAllowed ? Colors.white.withOpacity(0) : Colors.grey,
              BlendMode.multiply,
            ),
            child: ClipRect(
              child: Row(
                children: [
                  //
                  // > select view
                  //
                  if (serviceView == '')
                    ServiceCardView(
                      serviceAt: service,
                      parentSize: parentSize,
                    )
                  else if (serviceView == 'tile')
                    ServiceCardTileView(
                      serviceAt: service,
                      parentSize: parentSize,
                    )
                  else if (serviceView == 'square')
                    ServiceCardSquareView(
                      serviceAt: service,
                      parentSize: parentSize,
                    ),
                ],
              ),
            ),
          ),
          //
          // InkWell animation and handler
          //
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: service.add,
              onLongPress: () {
                // set last service
                ref.read(lastClientServiceId.notifier).state = service.servId;
                // open ClientServiceScreen
                Navigator.pushNamed(context, '/service');
              },
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
