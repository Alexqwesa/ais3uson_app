import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
/// Display list of proofs assigned to [ClientService].
///
/// On first build it create list from filesystem data.
class ServiceProof extends StatefulWidget {
  final ClientService clientService;

  const ServiceProof({
    required this.clientService,
    Key? key,
  }) : super(key: key);

  @override
  _ServiceProofState createState() => _ServiceProofState();
}

class _ServiceProofState extends State<ServiceProof> {
  List<String> audioPaths = [];
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientService = widget.clientService;

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
              ],
            ),
          ),

          ChangeNotifierProvider.value(
            value: clientService.proofList,
            child: Column(
              children: [
                //
                // > column's titles
                //
                Center(
                  child: Row(
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
                ),

                //
                // > main columns
                //
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
            ),
          ),
        ],
      ),
    );
  }
}
