import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/client_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Displays one [ClientService].
class ServiceCard extends StatefulWidget {
  final ClientService service;
  final double width;

  const ServiceCard({
    required this.service,
    required this.width,
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
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            enabled ? Colors.white : Colors.grey.withOpacity(.8),
            BlendMode.multiply,
          ),
          child: ServiceCardView(
            service: widget.service,
            parentWidth: widget.width,
          ),
        ),
        //
        // InkWell animation and handler
        //
        Positioned.fill(
          child: Material(
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
        ),
      ],
    );
  }
}

/// Displays text, icon, etc of [ClientService].
class ServiceCardView extends StatelessWidget {
  final ClientService service;
  final double parentWidth;
  late final double cardWidth;

  ServiceCardView({
    required this.service,
    required this.parentWidth,
    Key? key,
  }) : super(key: key) {
    cardWidth = parentWidth / (parentWidth ~/ 250.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardWidth * 1.2,
      width: cardWidth * 1.0,
      child: Card(
        elevation: 12,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                height: 90,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform.scale(
                        scale: 1.5,
                        child: ServiceCardState(
                          clientService: service,
                        ),
                      ),
                    ),
                    //
                    // > service image
                    //
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: service.servId,
                          child: SizedBox(
                            height: 90,
                            width: 90,
                            child: Image.asset(
                              'images/${service.image}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            // > service text
            //
            Center(
              child: SizedBox(
                height: cardWidth * 1.2 - 102,
                width: 200,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          service.shortText,
                          textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                        child: Text(
                          service.servTextAdd,
                          softWrap: true,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  const ServiceCardState({required this.clientService, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 14, 1, 1),
      child: SizedBox(
        height: 70,
        width: 10,
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
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return FittedBox(
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: listDoneProgressError.elementAt(i) != 0,
                      child: Column(
                        children: [
                          icons.elementAt(i),
                          Text(
                            listDoneProgressError.elementAt(i).toString(),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
