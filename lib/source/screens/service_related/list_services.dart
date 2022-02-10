import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';

class ListServices extends StatelessWidget {
  late final List<ClientService> _servListOfClient;
  late final double _width;

  ListServices({
    required List<ClientService> servListOfClient,
    Key? key,
    double? width,
  }) : super(key: key) {
    _servListOfClient = servListOfClient;
    _width = width ?? double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (_width < 600) ? _width / 2.1 : 250.0;

    return Container(
      child: _servListOfClient.isNotEmpty
          ? Center(
              child: Wrap(
                children: List.of(
                  _servListOfClient.map(
                    (element) {
                      return ServiceCard(
                        service: element,
                        width: cardWidth,
                      );
                    },
                  ),
                  growable: false,
                ),
              ),
            )
          : const Text(
              'Список положенных услуг пуст, \n\n'
              'возможно заведующий отделением уже закрыл договор\n\n'
              'обновите список',
              textAlign: TextAlign.center,
            ),
    );
  }
}
