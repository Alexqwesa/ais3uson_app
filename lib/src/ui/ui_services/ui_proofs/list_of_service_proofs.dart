// ignore_for_file: use_build_context_synchronously, unnecessary_import

import 'dart:async';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_proofs.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Display list of proofs assigned to [ClientService].
///
/// On first build it create list from filesystem data.
///
/// {@category UI Services}
/// {@category UI Proofs}
class ListOfServiceProofs extends ConsumerWidget {
  const ListOfServiceProofs({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final (_, proofController) = ref.watch(serviceProofAtDate(clientService));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        // > header
        //
        const _ProofsHeaderText(),
        //
        // > display list of proofs in columns
        //
        const ProofsBuilder(),
        //
        // > button to add new proof (new row)
        //
        FloatingActionButton(
          onPressed: proofController.addProof,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _ProofsHeaderText extends StatelessWidget {
  const _ProofsHeaderText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Divider(),
          ),
          Text(
            tr().optional,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            tr().proofOfService,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }
}

/// Display list of proofs in two columns.
///
/// If there is missing image - display add button [AddProofButton].
/// {@category UI Proofs}
class ProofsBuilder extends ConsumerWidget {
  const ProofsBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final (proofs, proofController) =
        ref.watch(serviceProofAtDate(clientService));

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            // > column's titles
            //
            if (proofs.isNotEmpty)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        tr().before,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tr().after,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),

            //
            // > main columns
            //

            if (proofs.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //
                  // > audio proofs
                  //
                  if (proofs.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofWidget(
                              proofs: (proofs, proofController),
                              beforeOrAfter: 'before_audio_',
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: AudioProofWidget(
                              proofs: (proofs, proofController),
                              // beforeOrAfter: 'after_audio_',
                            ),
                          ),
                        ),
                      ],
                    ),
                  //
                  // > photo proofs
                  //
                  for (int i = 0; i < proofs.length; i++)
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
  });

  final String beforeOrAfter;
  final int proofIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientService = ref.watch(currentService);
    final (proofs, proofController) =
        ref.watch(serviceProofAtDate(clientService));

    final valueKey = ValueKey(
      '${proofIndex}___$beforeOrAfter',
    );
    final image = proofs[proofIndex]['${beforeOrAfter}img_'] as Image?;

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
                indexInProofs: proofIndex,
                callAddProof: proofController.addImage,
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
    required this.indexInProofs,
    required this.callAddProof,
    required this.beforeOrAfter,
    super.key,
  });

  final int indexInProofs;
  final Function(int, XFile?, String) callAddProof;

  /// Either before_ or after_
  final String beforeOrAfter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        heroTag: ValueKey(beforeOrAfter + indexInProofs.toString()),
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          late final List<CameraDescription> cameras;
          try {
            cameras = await availableCameras();
          } on MissingPluginException {
            showErrorNotification(tr().cameraAccessDenied);

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
            indexInProofs,
            defaultImgPath,
            beforeOrAfter,
          );
        },
      ),
    );
  }
}
