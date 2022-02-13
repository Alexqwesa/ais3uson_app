import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/client_service_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays one [ClientService].
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
      size: AppData.instance.serviceSize(widget.parentSize),
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

/// Display state of the client service: amount of done/added/rejected.
///
/// It get data from [ClientService.journal] and count these 3 numbers:
/// - done - finished and outDated,
/// - inProgress - added and stale,
/// - error - rejected.
class ServiceCardState extends StatelessWidget {
  //
  // icon data
  //
  static const icons = <Icon>[
    Icon(
      Icons.volunteer_activism,
      color: Colors.green,
    ),
    Icon(
      Icons.update,
      color: Colors.orange,
    ),
    Icon(
      Icons.do_not_touch_outlined,
      color: Colors.red,
    ),
  ];

  final ClientService clientService;

  final bool rigthOfText;

  const ServiceCardState({
    required this.clientService,
    Key? key,
    this.rigthOfText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.fitHeight,
        child: SizedBox(
          height: 64 - (rigthOfText ? 10: 0),
          width: 10 + (rigthOfText ? 14 : 0),
          child: ChangeNotifierProvider<ClientService>.value(
            value: clientService,
            child: Consumer<ClientService>(
              builder: (context, data, child) {
                final listDoneProgressError =
                    context.select<ClientService, List<int>>(
                  (data) => data.listDoneProgressError,
                );

                return ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return FittedBox(
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: listDoneProgressError.elementAt(i) != 0,
                        child: rigthOfText
                            ? Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    icons.elementAt(i),
                                    Text(
                                      listDoneProgressError
                                          .elementAt(i)
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    icons.elementAt(i),
                                    Text(
                                      listDoneProgressError
                                          .elementAt(i)
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
