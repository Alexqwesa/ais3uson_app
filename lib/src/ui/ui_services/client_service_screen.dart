import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_proofs.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Display one [ClientService] on fullscreen.
///
/// {@category UI Services}
class ClientServiceScreen extends ConsumerWidget {
  const ClientServiceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(currentService);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width < height ? size.width : height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.shortText,
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                    child: SizedBox(
                      height: width / 3,
                      child: Row(
                        children: [
                          const Spacer(),
                          //
                          // > service state icons
                          //
                          SizedBox(
                            height: width / 4,
                            width: width / 5,
                            child: const ServiceCardState(
                              rightOfText: true,
                            ),
                          ),

                          const Spacer(),
                          //
                          // > service image
                          //
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Hero(
                                tag: service.servId,
                                child: SizedBox(
                                  height: width / 2,
                                  width: width / 2,
                                  child: Image.asset(
                                    'images/${service.image}',
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),
                          Expanded(
                            flex: 3,
                            // height: width / 2,
                            // width: width / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //
                                // > buttons Add / Delete
                                //
                                AddButton(service: service),
                                const Spacer(),
                                DeleteButton(service: service),
                              ],
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
                      height: 200,
                      // width: 200,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                service.shortText,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                              child: Text(
                                service.servTextAdd,
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  // > prof of service
                  //
                  if (!kIsWeb) const ListOfServiceProofs(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Button to add new [ServiceOfJournal], used in [ClientServiceScreen].
///
/// {@category UI Services}
class AddButton extends ConsumerWidget {
  const AddButton({
    required this.service,
    super.key,
  });

  final ClientService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceState = ref.watch(serviceStateProvider(service));
    final allowed = serviceState.addAllowed;

    return FittedBox(
      fit: BoxFit.fitHeight,
      child: IconButton(
        onPressed: allowed ? serviceState.add : null,
        icon: Transform.scale(
          scale: 2.5,
          child: Icon(
            Icons.publish_rounded,
            color: allowed ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Button to delete [ServiceOfJournal], used in [ClientServiceScreen].
///
/// {@category UI Services}
class DeleteButton extends ConsumerWidget {
  const DeleteButton({
    required this.service,
    super.key,
  });

  final ClientService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceState = ref.watch(serviceStateProvider(service));
    final allowed = serviceState.deleteAllowed;

    return FittedBox(
      fit: BoxFit.fitHeight,
      child: IconButton(
        onPressed: allowed ? serviceState.delete : null,
        icon: Transform.scale(
          scale: 2.5,
          child: Transform.rotate(
            angle: 3.14,
            child: Icon(
              Icons.publish_rounded,
              color: allowed ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
