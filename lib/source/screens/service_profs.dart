import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ServiceProfs extends StatelessWidget {
  final ClientService clientService;

  const ServiceProfs({
    required this.clientService,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final serv = clientService;
    return SingleChildScrollView(
      child: Column(
        children: [
          //
          // > header
          //
          Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                ),
                Text(
                  'НЕОБЯЗАТЕЛЬНО!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  'Подтверждение оказания услуги:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Сделайте снимки или аудиозаписи подтверждающие оказание услуги:',
                    textAlign: TextAlign.center,
                  ),
                ),
                //
                // > column's titles
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        'До:',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'После:',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //
          // > main columns
          //
          ChangeNotifierProvider<ClientService>.value(
            value: clientService,
            child: Consumer<ClientService>(
              builder: (context, clientService, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [],
                        ),
                        const VerticalDivider(),
                        Column(
                          children: [],
                        ),
                      ],
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
