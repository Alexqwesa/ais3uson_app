// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/client_service_at.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/repository_of_prooflist.dart';
import 'package:ais3uson_app/source/screens/service_related/audio_proof_controller.dart';
import 'package:ais3uson_app/source/screens/service_related/camera.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
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
    required this.clientServiceAt,
    // required this.clientProfile,
    // this.date,
    Key? key,
  }) : super(key: key);

  // final ClientProfile clientProfile;
  final ClientServiceAt clientServiceAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proofList = ref.watch(servProofAtDate(Tuple2(
      clientServiceAt.date?.dateOnly(),
      clientServiceAt.clientService,
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
                locator<S>().optional,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                locator<S>().proofOfService,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  locator<S>().makeProofOfService,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        //
        // > Display list of proofs in columns
        //
        ProofListBuilder(
          clientServiceAt: clientServiceAt,
        ),
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
    required this.clientServiceAt,
    Key? key,
  }) : super(key: key);

  final ClientServiceAt clientServiceAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proofList = ref.watch(servProofAtDate(Tuple2(
      clientServiceAt.date?.dateOnly(),
      clientServiceAt.clientService,
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
            if (proofList.proofGroups.isNotEmpty)
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

            if (proofList.proofGroups.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //
                  // > audio proofs
                  //
                  if (proofList.proofGroups.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofController(
                              proof: proofList,
                              beforeOrAfter: 'before_audio_',
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofController(
                              proof: proofList,
                              // beforeOrAfter: 'after_audio_',
                            ),
                          ),
                        ),
                      ],
                    ),
                  //
                  // > photo proofs
                  //
                  for (int i = 0; i < proofList.proofGroups.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox.square(
                              child: ImageOrButtonAdd(
                                image: proofGroups[i].beforeImg,
                                addProofButton: AddProofButton(
                                  indexInProofList: i,
                                  callAddProof: proofList.addImage,
                                  strBeforeOrAfter: 'before_',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox.square(
                              // dimension: MediaQuery.of(context).size.width / 2.4,
                              child: ImageOrButtonAdd(
                                image: proofGroups[i].afterImg,
                                addProofButton: AddProofButton(
                                  indexInProofList: i,
                                  callAddProof: proofList.addImage,
                                  strBeforeOrAfter: 'after_',
                                ),
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
class ImageOrButtonAdd extends StatelessWidget {
  const ImageOrButtonAdd({
    required this.addProofButton,
    required this.image,
    Key? key,
  }) : super(key: key);

  final Widget addProofButton;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (image != null)
          ? Hero(
              key: ValueKey(image.toString()),
              tag: ValueKey(image.toString()),
              child: GestureDetector(
                child: image,
                onTap: () {
                  unawaited(
                    Navigator.push(
                      context,
                      MaterialPageRoute<XFile>(
                        builder: (context) => DisplayPictureScreen(
                          image: image!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(child: addProofButton),
    );
  }
}

/// Display add button for add proof.
///
/// {@category UI Proofs}
class AddProofButton extends StatelessWidget {
  const AddProofButton({
    required this.indexInProofList,
    required this.callAddProof,
    required this.strBeforeOrAfter,
    Key? key,
  }) : super(key: key);

  final int indexInProofList;
  final Function(int, XFile?, String) callAddProof;

  /// Either before_ or after_
  final String strBeforeOrAfter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        heroTag: ValueKey(strBeforeOrAfter + indexInProofList.toString()),
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
            strBeforeOrAfter,
          );
        },
      ),
    );
  }
}
