import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_card.dart';
import 'package:flutter/cupertino.dart';
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
    final width=MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(
        widget.service.shortText,),),
      body: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: width/3,
                child: Row(
                  children: [
                    //
                    // > service state icons
                    //
                    Align(
                      alignment: Alignment.topLeft,
                      child: Transform.scale(
                        scale: 2.5,
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
                          height: width/2,
                          width: width/2,
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
                // height: width * 1.2 - 102,
                // width: 200,
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
    );
  }
}
