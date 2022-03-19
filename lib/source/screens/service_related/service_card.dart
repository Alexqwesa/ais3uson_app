import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/client_service_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays one [ClientService].
///
/// This widget check is service enabled.
/// And decide which View to use(like: [ServiceCardView], [ServiceCardTileView], [ServiceCardSquareView]...)
///
/// {@category UIServices}
class ServiceCard extends StatelessWidget {
  final ClientService service;
  final Size parentSize;

  const ServiceCard({
    required this.service,
    required this.parentSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: locator<AppData>().serviceCardSize(parentSize),
      child: Stack(
        children: [
          ChangeNotifierProvider.value(
            value: service,
            child: Consumer<ClientService>(
              builder: (context, state, _) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    service.addAllowed
                        ? Colors.white.withOpacity(0)
                        : Colors.grey,
                    BlendMode.multiply,
                  ),
                  child: ChangeNotifierProvider.value(
                    value: AppData.instance,
                    child: Consumer<AppData>(
                      builder: (context, data, _) {
                        return Row(
                          children: [
                            //
                            // > select view
                            //
                            if (locator<AppData>().serviceView == '')
                              ServiceCardView(
                                service: service,
                                parentWidth: parentSize,
                              )
                            else if (locator<AppData>().serviceView == 'tile')
                              ServiceCardTileView(
                                service: service,
                                parentWidth: parentSize,
                              )
                            else if (locator<AppData>().serviceView == 'square')
                              ServiceCardSquareView(
                                service: service,
                                parentWidth: parentSize,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
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
