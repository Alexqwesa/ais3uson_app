import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
import 'package:flutter/material.dart';

class ListServices extends StatelessWidget {
  late final List<ClientService> _servListFio;
  late final double _width;

  ListServices({
    required List<ClientService> servListFio,
    Key? key,
    double? width,
  }) : super(key: key) {
    _servListFio = servListFio;
    _width = width ?? double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _servListFio.isNotEmpty
          ? Center(
              child: Transform.scale(
                scale: 1,
                child: Wrap(
                  children: List.generate(
                    _servListFio.length,
                    (index) {

                      return ServiceCard(
                        key: ValueKey(_servListFio[index].servId),
                        service: _servListFio[index],
                        // service: AppData().services.firstWhere(
                        //       (element) =>
                        //           element.id == _servListFio[index].servId,
                        //     ),
                        width: (_width < 600) ? _width / 2.1 : 250,
                      );
                    },
                  ),
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
