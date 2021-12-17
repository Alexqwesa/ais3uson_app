import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/src/screens/service_card.dart';
import 'package:flutter/material.dart';

class ListServices extends StatelessWidget {
  late List<FioPlanned> _servListFio;
  double _width = double.infinity;

  ListServices({Key? key, required List<FioPlanned> servListFio, double? width})
      : super(key: key) {
    _servListFio = servListFio;
    _width = width ?? _width;
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
                      return Transform.scale(
                        scale: 1,
                        child: ServiceCard(
                          key: ValueKey(_servListFio[index].servId),
                          service: AppData().services.firstWhere(
                                (element) =>
                                    element.id == _servListFio[index].servId,
                              ),
                          width: (_width < 600) ? _width / 2.1 : 250,
                        ),
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
