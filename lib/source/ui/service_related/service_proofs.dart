// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/ui/service_related/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Display list of proofs assigned to [ClientService].
///
/// On first build it create list from filesystem data.
///
/// {@category UI Services}
class ServiceProof extends StatefulWidget {
  const ServiceProof({
    required this.clientService,
    Key? key,
  }) : super(key: key);

  final ClientService clientService;

  @override
  ServiceProofState createState() => ServiceProofState();
}

class ServiceProofState extends State<ServiceProof> {
  List<String> audioPaths = [];
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    final clientService = widget.clientService;
    final proofList = clientService.proofList;

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
                padding: EdgeInsets.all(8),
                child: Text(
                  'Сделайте снимки или аудиозаписи '
                  'подтверждающие оказание услуги:',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        //
        // > Display list of proofs in two columns
        //
        BuildProofList(proofList: proofList),
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
class BuildProofList extends StatelessWidget {
  const BuildProofList({required this.proofList, Key? key}) : super(key: key);

  final ProofList proofList;

  @override
  Widget build(BuildContext context) {
    final proofGroups = proofList.proofGroups;

    return ChangeNotifierProvider.value(
      value: proofList,
      child: Consumer<ProofList>(
        builder: (context, proofList, _) {
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
                        for (int i = 0; i < proofList.proofGroups.length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox.square(
                                    child: Expanded(
                                      child: ImageOrButtonAdd(
                                        image: proofGroups[i].beforeImg,
                                        addProfButton: AddProofButton(
                                          indexInProofList: i,
                                          callBack: proofList.addImage,
                                          strBeforAfter: 'before_',
                                        ),
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
                                    child: Expanded(
                                      child: ImageOrButtonAdd(
                                        image: proofGroups[i].afterImg,
                                        addProfButton: AddProofButton(
                                          indexInProofList: i,
                                          callBack: proofList.addImage,
                                          strBeforAfter: 'after_',
                                        ),
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
        },
      ),
    );
  }
}

class ImageOrButtonAdd extends StatelessWidget {
  const ImageOrButtonAdd({
    required this.addProfButton,
    required this.image,
    Key? key,
  }) : super(key: key);

  final Widget addProfButton;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (image != null)
          ? FittedBox(
              child: Hero(
                tag: ValueKey(
                  image.toString(),
                ),
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
              ),
            )
          : Center(child: addProfButton),
    );
  }
}

/// Display add button for add proof.
class AddProofButton extends StatelessWidget {
  const AddProofButton({
    required this.indexInProofList,
    required this.callBack,
    required this.strBeforAfter,
    Key? key,
  }) : super(key: key);

  final int indexInProofList;
  final Function(int, XFile?, String) callBack;
  final String strBeforAfter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        heroTag: ValueKey(strBeforAfter + indexInProofList.toString()),
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
              builder: (context) => TakePictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: cameras.first,
              ),
            ),
          );
          await callBack(indexInProofList, defaultImgPath, strBeforAfter);
        },
      ),
    );
  }
}
