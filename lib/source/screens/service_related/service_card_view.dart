import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card_state.dart';
import 'package:flutter/material.dart';

/// Displays text, icon, etc of [ClientService] - default view.
///
/// {@category UIServices}
class ServiceCardView extends StatelessWidget {
  final ClientService service;
  final Size parentWidth;

  const ServiceCardView({
    required this.service,
    required this.parentWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: AppData.instance.serviceCardSize(parentWidth),
      child: Card(
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              SizedBox(
                height: 100,
                child: ServiceCardState(
                  clientService: service,
                  rightOfText: true,
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                    //
                    // > service image
                    //
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
                  //
                  // > service text
                  //
                  Center(
                    child: SizedBox(
                      height: 120,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays icon, and caption of [ClientService] - square view.
///
/// {@category UIServices}
class ServiceCardSquareView extends StatelessWidget {
  final ClientService service;
  final Size parentWidth;

  const ServiceCardSquareView({
    required this.service,
    required this.parentWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: AppData.instance.serviceCardSize(parentWidth),
      child: FittedBox(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 4, 2),
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: service.servId,
                        child: SizedBox(
                          height: 90,
                          width: 90,
                          child: Image.asset(
                            'images/${service.image}',
                          ),
                        ),
                      ),
                      const Divider(
                        height: 3,
                      ),
                      //
                      // > service text
                      //
                      Center(
                        child: Text(
                          service.shortText,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: const Alignment(-1, -0.9),
              //   child:
              SizedBox(
                height: 50,
                child: ServiceCardState(
                  clientService: service,
                  rightOfText: true,
                ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays text, icon, etc of [ClientService] - tile view.
///
/// {@category UIServices}
class ServiceCardTileView extends StatelessWidget {
  final ClientService service;
  final Size parentWidth;

  const ServiceCardTileView({
    required this.service,
    required this.parentWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: AppData.instance.serviceCardSize(parentWidth),
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          height: 100,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 6,
              child: Stack(
                children: [
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Hero(
                          tag: service.servId,
                          child: Image.asset(
                            'images/${service.image}',
                          ),
                        ),
                      ),
                      //
                      // > service text
                      //
                      SizedBox(
                        height: 100,
                        width: 288,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  service.shortText,
                                  textScaleFactor: 1.1,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                                child: Text(
                                  service.servTextAdd,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  // > service state
                  //
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 50,
                      height: 88,
                      child: ServiceCardState(
                        clientService: service,
                        rightOfText: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
