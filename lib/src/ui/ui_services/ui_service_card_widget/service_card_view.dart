import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays text, icon, etc of [ClientService] - default view.
///
/// {@category UI Services}
class ServiceCardView extends ConsumerWidget {
  const ServiceCardView({
    super.key,
  });

  static const tileType = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(currentService);
    final addAllowed = ref.watch(
        serviceStateProvider(service).select((value) => value.addAllowed));

    return FittedBox(
      child: SizedBox(
        width: 205,
        height: 230,
        child: Card(
          elevation: addAllowed ? 6 : 0,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Stack(
              children: [
                const SizedBox(
                  height: 100,
                  child: ServiceCardState(
                    rightOfText: true,
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 90,
                      //
                      // > service image
                      //
                      child: Hero(
                        tag: service.servId,
                        child: SizedBox(
                          height: 90,
                          width: 90,
                          child: ref.watch(image(service.image)),
                        ),
                      ),
                    ),
                    //
                    // > service text
                    //
                    Center(
                      child: SizedBox(
                        height: 128,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  service.shortText,
                                  textScaleFactor: 1.1,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                                child: Text(
                                  service.servTextAdd,
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays icon, and caption of [ClientService] - square view.
///
/// Note: this view is broken, bug report: https://github.com/flutter/flutter/issues/98809
///
/// {@category UI Services}
class ServiceCardSquareView extends ConsumerWidget {
  const ServiceCardSquareView({
    super.key,
  });

  static const tileType = 'square';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(currentService);
    final addAllowed = ref.watch(
        serviceStateProvider(service).select((value) => value.addAllowed));

    return FittedBox(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 4, 2),
              child: Card(
                elevation: addAllowed ? 6 : 0,
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: service.servId,
                      child: SizedBox(
                        height: 90,
                        width: 90,
                        child: ref.watch(image(service.image)),
                      ),
                    ),
                    const Divider(
                      height: 3,
                    ),
                    //
                    // > service text
                    //
                    Center(
                      child: Text(
                        service.shortText,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
              child: ServiceCardState(
                rightOfText: true,
              ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays text, icon, etc of [ClientService] - tile view.
///
/// {@category UI Services}
class ServiceCardTileView extends ConsumerWidget {
  const ServiceCardTileView({
    super.key,
  });

  static const tileType = 'tile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(currentService);
    final addAllowed = ref.watch(
        serviceStateProvider(service).select((value) => value.addAllowed));

    return FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(
        height: 100,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Card(
            elevation: addAllowed ? 6 : 0,
            child: Stack(
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Hero(
                        tag: service.servId,
                        child: ref.watch(image(service.image)),
                      ),
                    ),
                    //
                    // > service text
                    //
                    SizedBox(
                      height: 100,
                      width: 288,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                service.shortText,
                                textScaleFactor: 1.1,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                              child: Text(
                                service.servTextAdd,
                                textAlign: TextAlign.left,
                                softWrap: true,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
                // > service state
                //
                const Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 50,
                    height: 88,
                    child: ServiceCardState(
                      rightOfText: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
