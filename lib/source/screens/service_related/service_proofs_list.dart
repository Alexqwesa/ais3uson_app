// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/proofs/repository_of_prooflist.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/screens/service_related/audio_proof_controller.dart';
import 'package:ais3uson_app/source/screens/service_related/camera.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen_provider_helper.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Display list of proofs assigned to [ClientService].
///
/// On first build it create list from filesystem data.
///
/// {@category UI Services}
/// {@category UI Proofs}
class ServiceProofList extends ConsumerWidget {
  const ServiceProofList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final proofList = ref.watch(servProofAtDate(Tuple2(
      clientService.date ??
          ref.watch(archiveDate) ??
          DateTimeExtensions.today(),
      clientService,
    )));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        // > header
        //
        Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Divider(),
              ),
              Text(
                tr().optional,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                tr().proofOfService,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  tr().makeProofOfService,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        //
        // > Display list of proofs in columns
        //
        const ProofListBuilder(),
        //
        // > add new record(proof row) button
        //
        FloatingActionButton(
          onPressed: proofList.addNewGroup,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// Display list of proofs in two columns.
///
/// If there is missing image - display add button [AddProofButton].
/// {@category UI Proofs}
class ProofListBuilder extends ConsumerWidget {
  const ProofListBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final proofList = ref.watch(servProofAtDate(Tuple2(
      clientService.date ??
          ref.watch(archiveDate) ??
          DateTimeExtensions.today(),
      clientService,
    )));
    final proofGroups = ref.watch(groupsOfProof(proofList));

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            // > column's titles
            //
            if (proofGroups.isNotEmpty)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        tr().before,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tr().after,
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

            if (proofGroups.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //
                  // > audio proofs
                  //
                  if (proofGroups.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofController(
                              proofs: proofList,
                              beforeOrAfter: 'before_audio_',
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofController(
                              proofs: proofList,
                              // beforeOrAfter: 'after_audio_',
                            ),
                          ),
                        ),
                      ],
                    ),
                  //
                  // > photo proofs
                  //
                  for (int i = 0; i < proofGroups.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox.square(
                              child: _ImageOrButtonAdd(
                                proofIndex: i,
                                beforeOrAfter: 'before_',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox.square(
                              child: _ImageOrButtonAdd(
                                proofIndex: i,
                                beforeOrAfter: 'after_',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// Show add button or Image.
///
/// {@category UI Proofs}
class _ImageOrButtonAdd extends ConsumerWidget {
  const _ImageOrButtonAdd({
    required this.proofIndex,
    required this.beforeOrAfter,
    Key? key,
  }) : super(key: key);

  final String beforeOrAfter;
  final int proofIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final proofList = ref.watch(servProofAtDate(Tuple2(
      clientService.date ??
          ref.watch(archiveDate) ??
          DateTimeExtensions.today(),
      clientService,
    )));
    final proofGroups = ref.watch(groupsOfProof(proofList));

    final valueKey = ValueKey(
      '${proofIndex}___$beforeOrAfter',
    );
    final image = proofGroups[proofIndex]['${beforeOrAfter}img_'] as Image?;

    return Center(
      child: (image != null)
          ? Hero(
              key: valueKey,
              tag: valueKey,
              child: GestureDetector(
                child: image,
                onTap: () {
                  unawaited(
                    Navigator.push(
                      context,
                      MaterialPageRoute<XFile>(
                        builder: (context) => DisplayPictureScreen(
                          image: image,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: AddProofButton(
                indexInProofList: proofIndex,
                callAddProof: proofList.addImage,
                beforeOrAfter: beforeOrAfter,
              ),
            ),
    );
  }
}

/// Display add button which add image proof.
///
/// {@category UI Proofs}
class AddProofButton extends StatelessWidget {
  const AddProofButton({
    required this.indexInProofList,
    required this.callAddProof,
    required this.beforeOrAfter,
    Key? key,
  }) : super(key: key);

  final int indexInProofList;
  final Function(int, XFile?, String) callAddProof;

  /// Either before_ or after_
  final String beforeOrAfter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        heroTag: ValueKey(beforeOrAfter + indexInProofList.toString()),
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          late final List<CameraDescription> cameras;
          try {
            cameras = await availableCameras();
          } on MissingPluginException {
            showErrorNotification(
              'Ошибка: нет доступа к камере!',
            );

            return;
          }
          // if (!mounted) return;
          final defaultImgPath = await Navigator.push(
            context,
            MaterialPageRoute<XFile>(
              builder: (context) => TakeProofPictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: cameras.first,
              ),
            ),
          );
          await callAddProof(
            indexInProofList,
            defaultImgPath,
            beforeOrAfter,
          );
        },
      ),
    );
  }
}
