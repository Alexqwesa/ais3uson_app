import 'dart:ui';

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:ais3uson_app/source/screens/service_related/service_proofs.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  final ClientService service;

  const CardScreen({
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < height
        ? MediaQuery.of(context).size.width
        : height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service.shortText,
        ),
      ),
      body: SizedBox(
        width: width,
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 20, 12, 12),
                child: SizedBox(
                  height: width / 3,
                  child: Row(
                    children: [
                      const Spacer(),
                      //
                      // > service state icons
                      //
                      Expanded(
                        child: Align(
                          child: Transform.scale(
                            scale: 2.5,
                            child: ServiceCardState(
                              clientService: widget.service,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      //
                      // > service image
                      //
                      Expanded(
                        flex: 6,
                        child: Center(
                          child: SizedBox(
                            height: width / 2,
                            width: width / 2,
                            child: Image.asset(
                              'images/${widget.service.image}',
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      Expanded(
                        flex: 3,
                        // height: width / 2,
                        // width: width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitHeight,
                              child: IconButton(
                                onPressed: () {
                                  widget.service.add();
                                },
                                icon: Transform.scale(
                                  scale: 2.5,
                                  child: const Icon(
                                    Icons.publish_rounded,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            FittedBox(
                              fit: BoxFit.fitHeight,
                              child: IconButton(
                                onPressed: () {
                                  widget.service.delete();
                                },
                                icon: Transform.rotate(
                                  angle: 3.14,
                                  child: Transform.scale(
                                    scale: 2.5,
                                    child: const Icon(
                                      Icons.publish_rounded,
                                      color: Colors.red,
                                    ),
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
              ),
              //
              // > service text
              //
              Center(
                child: SizedBox(
                  // height: width * 1.2 - 102,
                  // width: 200,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                          child: Text(
                            widget.service.servTextAdd,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              // > prof of service
              //
              ServiceProof(clientService: widget.service),
            ],
          ),
        ),
      ),
    );
  }
}
