import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/client_service_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_view.dart';
import 'package:flutter/material.dart';

/// Displays one [ClientService].
///
/// {@category UIServices}
class ServiceCard extends StatefulWidget {
  final ClientService service;
  final Size parentSize;

  const ServiceCard({
    required this.service,
    required this.parentSize,
    Key? key,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool enabled = true;

  @override
  void initState() {
    enabled = widget.service.left > 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: AppData.instance.serviceCardSize(widget.parentSize),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              enabled ? Colors.white : Colors.grey.withOpacity(.8),
              BlendMode.multiply,
            ),
            child: Row(
              children: [
                //
                // > select view
                //
                if (AppData().serviceView == '')
                  ServiceCardView(
                    service: widget.service,
                    parentWidth: widget.parentSize,
                  )
                else if (AppData().serviceView == 'tile')
                  ServiceCardTileView(
                    service: widget.service,
                    parentWidth: widget.parentSize,
                  ),
              ],
            ),
          ),
          //
          // InkWell animation and handler
          //
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  enabled = widget.service.left > 0;
                  if (enabled) widget.service.add();
                  enabled = widget.service.left > 0;
                });
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<ClientServiceScreen>(
                    builder: (context) {
                      return ClientServiceScreen(
                        service: widget.service,
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
