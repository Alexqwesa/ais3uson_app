import 'dart:ui';

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/card_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatefulWidget {
  final ClientService service;
  final double width;

  const ServiceCard({
    required Key key,
    required this.service,
    required this.width,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool enabled = true;

  late AnimationController _controller;

  @override
  void initState() {
    enabled = widget.service.left > 0;
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.width * 1.2,
      width: widget.width * 1.0,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              enabled
                  ? Colors.white.withOpacity(0)
                  : Colors.grey.withOpacity(.8),
              BlendMode.multiply,
            ),
            child: Card(
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
                                clientService: widget.service,
                              ),
                            ),
                          ),
                          //
                          // > service image
                          //  
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                height: 90,
                                width: 90,
                                child: Image.asset(
                                  'images/${widget.service.image}',
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
                      height: widget.width * 1.2 - 102,
                      width: 200,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                widget.service.shortText,
                                textScaleFactor: 1.1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                              child: Text(
                                widget.service.servTextAdd,
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
          ),
          // 
          // InkWell animation and handler 
          //  
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.amber.withOpacity(0.5),
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
                  MaterialPageRoute<CardScreen>(
                    builder: (context) {
                      return CardScreen(
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

/// ServiceCardState
///
/// Display state of the client service
/// states: done, pending, rejected (all in numbers)
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
