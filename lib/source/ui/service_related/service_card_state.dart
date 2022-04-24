import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/providers/repository_of_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Display state of the client service: amount of done/added/rejected...
///
/// It get data from [ClientService.journal]
/// via [ref.watch(listDoneProgressErrorOfService(clientService))],
/// these numbers mean:
/// - done - finished and outDated,
/// - progress - added,
/// - error - rejected.
///
/// {@category UI Services}
class ServiceCardState extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final listDoneProgressError =
        ref.watch(listDoneProgressErrorOfService(clientService));

    return SizedBox.expand(
      child: FittedBox(
        alignment: Alignment.topLeft,
        fit: BoxFit.fitHeight,
        child: SizedBox(
          height: 64 - (rightOfText ? 10 : 0),
          width: 10 + (rightOfText ? 14 : 0),
          child: ListView.builder(
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
                                listDoneProgressError.elementAt(i).toString(),
                                style: Theme.of(context).textTheme.headline5,
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
                                listDoneProgressError.elementAt(i).toString(),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
