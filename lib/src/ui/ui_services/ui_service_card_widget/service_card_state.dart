import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Display state of the client service: amount of done/added/rejected...
///
/// It present data of the client service state [serviceStateProvider].fullState
/// these numbers mean:
/// - done - finished + outDated,
/// - stale - added,
/// - error - rejected.
///
/// {@category UI Services}
class ServiceCardState extends StatelessWidget {
  const ServiceCardState({
    super.key,
    this.rightOfText = false,
  });

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
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return FittedBox(
                child: Consumer(builder: (context, ref, _) {
                  final service = ref.watch(currentService);
                  final serviceState = ref.watch(serviceStateProvider(service));
                  final listDoneProgressError = serviceState.fullState;

                  return Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: listDoneProgressError.elementAt(i) != 0,
                    child: rightOfText
                        ? Row(
                            children: [
                              icons.elementAt(i),
                              Text(
                                listDoneProgressError.elementAt(i).toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              icons.elementAt(i),
                              Text(
                                listDoneProgressError.elementAt(i).toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
