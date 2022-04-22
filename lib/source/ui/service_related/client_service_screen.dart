import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card_state.dart';
import 'package:ais3uson_app/source/ui/service_related/service_proofs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Display one [ClientService] on fullscreen.
///
/// {@category UI Services}
class ClientServiceScreen extends StatefulWidget {
  const ClientServiceScreen({
    required this.service,
    Key? key,
  }) : super(key: key);

  final ClientService service;

  @override
  ClientServiceScreenState createState() => ClientServiceScreenState();
}

class ClientServiceScreenState extends State<ClientServiceScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < height
        ? MediaQuery.of(context).size.width
        : height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service.shortText,
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
                            child: ServiceCardState(
                              clientService: widget.service,
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
                                tag: widget.service.servId,
                                child: SizedBox(
                                  height: width / 2,
                                  width: width / 2,
                                  child: Image.asset(
                                    'images/${widget.service.image}',
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
                                AddButton(widget: widget),
                                const Spacer(),
                                DeleteButton(widget: widget),
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
                                widget.service.shortText,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                              child: Text(
                                widget.service.servTextAdd,
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
                  if (!kIsWeb) ServiceProof(clientService: widget.service),
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
    required this.widget,
    Key? key,
  }) : super(key: key);

  final ClientServiceScreen widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: IconButton(
        onPressed: widget.service.add,
        icon: Transform.scale(
          scale: 2.5,
          child: Icon(
            Icons.publish_rounded,
            color: widget.service.addAllowed ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// Button to delete [ServiceOfJournal], used in [ClientServiceScreen].
///
/// {@category UI Services}
class DeleteButton extends StatelessWidget {
  const DeleteButton({
    required this.widget,
    Key? key,
  }) : super(key: key);

  final ClientServiceScreen widget;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: IconButton(
        onPressed: widget.service.delete,
        icon: Transform.scale(
          scale: 2.5,
          child: Transform.rotate(
            angle: 3.14,
            child: Icon(
              Icons.publish_rounded,
              color: widget.service.deleteAllowed ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
