import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Display state of the client service: amount of done/added/rejected...
///
/// It get data from [ClientService.journal]
/// via [ClientService.doneStaleError], these numbers mean:
/// - done - finished and outDated,
/// - inProgress - added and stale,
/// - error - rejected.
///
/// {@category UI Services}
class ServiceCardState extends StatelessWidget {
  const ServiceCardState({
    required this.clientService,
    Key? key,
    this.rightOfText = false,
  }) : super(key: key);

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

  final bool rightOfText;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.fitHeight,
        child: SizedBox(
          height: 64 - (rightOfText ? 10 : 0),
          width: 10 + (rightOfText ? 14 : 0),
          child: ChangeNotifierProvider<ClientService>.value(
            value: clientService,
            child: Consumer<ClientService>(
              builder: (context, data, child) {
                final listDoneProgressError =
                    context.select<ClientService, List<int>>(
                  (data) => data.doneStaleError,
                );

                return ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return FittedBox(
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: listDoneProgressError.elementAt(i) != 0,
                        child: rightOfText
                            ? Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    icons.elementAt(i),
                                    Text(
                                      listDoneProgressError
                                          .elementAt(i)
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    icons.elementAt(i),
                                    Text(
                                      listDoneProgressError
                                          .elementAt(i)
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
