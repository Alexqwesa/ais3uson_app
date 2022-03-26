import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/screens/service_related/client_service_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;

/// Displays one [ClientService].
///
/// This widget check is service enabled.
/// And decide which View to use(like: [ServiceCardView], [ServiceCardTileView], [ServiceCardSquareView]...)
///
/// {@category UIServices}
class ServiceCard extends ConsumerWidget {
  final ClientService service;
  final Size parentSize;

  const ServiceCard({
    required this.service,
    required this.parentSize,
    Key? key,
  }) : super(key: key);

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
                      service: service,
                      parentSize: parentSize,
                    )
                  else if (serviceView == 'tile')
                    ServiceCardTileView(
                      service: service,
                      parentSize: parentSize,
                    )
                  else if (serviceView == 'square')
                    ServiceCardSquareView(
                      service: service,
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
                Navigator.push(
                  context,
                  MaterialPageRoute<ClientServiceScreen>(
                    builder: (context) {
                      return ClientServiceScreen(
                        service: service,
                      );
                    },
                  ),
                );
              },
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
