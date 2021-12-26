import 'package:ais3uson_app/src/data_classes/client_service.dart';
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
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.service.addUsed();
          });
        },
        child: Stack(
          children: [
            Card(
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
          ],
        ),
      ),
    );
  }
}

class ServiceCardState extends StatelessWidget {
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
              final listDoneProgressError = context.select<ClientService, List<int>>(
                (data) => data.listDoneProgressError,
              );

              //
              // data
              //
              const icons = <Icon>[
                Icon(
                  Icons.volunteer_activism,
                  color: Colors.green,
                ),
                Icon(
                  Icons.update,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.do_not_touch_outlined,
                  color: Colors.red,
                ),
              ];

              return ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return FittedBox(
                    child: Column(
                      children: [
                        icons.elementAt(i),
                        Text(
                          listDoneProgressError.elementAt(i).toString(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
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
