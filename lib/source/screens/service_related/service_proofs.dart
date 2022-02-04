import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/screens/service_related/camera.dart';
import 'package:ais3uson_app/source/screens/service_related/proof_list.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

/// Display list of proofs assigned to [ClientService].
///
/// On first build it create list from filesystem data.
class ServiceProof extends StatefulWidget {
  final ClientService clientService;

  const ServiceProof({
    required this.clientService,
    Key? key,
  }) : super(key: key);

  @override
  _ServiceProofState createState() => _ServiceProofState();
}

class _ServiceProofState extends State<ServiceProof> {
  List<String> audioPaths = [];
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientService = widget.clientService;
    final proofList = clientService.proofList;
    // var proofGroups = proofList.proofGroups;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            // > header
            //
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Сделайте снимки или аудиозаписи подтверждающие оказание услуги:',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // height: MediaQuery.of(context).size.height,
            ChangeNotifierProvider.value(
              value: proofList,
              child: Consumer(
                builder: buildProofList,
              ),
            ),
            FloatingActionButton(
              onPressed: proofList.addNewGroup,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

// ignore: long-method
  Widget buildProofList(
    BuildContext context,
    ProofList proofList,
    Widget? child,
  ) {
    final proofGroups = proofList.proofGroups;

    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox.square(
                        dimension: MediaQuery.of(context).size.width / 2.4,
                        child: Center(
                          child: (proofGroups[i].beforeImg != null)
                              ? Hero(
                                  tag: ValueKey(
                                    proofGroups[i].beforeImg.toString(),
                                  ),
                                  child: GestureDetector(
                                    child: proofGroups[i].beforeImg,
                                    onTap: () {
                                      unawaited(
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<XFile>(
                                            builder: (context) =>
                                                DisplayPictureScreen(
                                              image: proofGroups[i].beforeImg!,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : FloatingActionButton(
                                  heroTag: ValueKey('before_$i'),
                                  child: const Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    final cameras = await availableCameras();
                                    // final firstCamera = cameras.first;
                                    if (!mounted) return;
                                    final defaultImgPath = await Navigator.push(
                                      context,
                                      MaterialPageRoute<XFile>(
                                        builder: (context) => TakePictureScreen(
                                          // Pass the appropriate camera to the TakePictureScreen widget.
                                          camera: cameras.first,
                                        ),
                                      ),
                                    );
                                    await proofList.addImage(
                                      i,
                                      defaultImgPath,
                                      'before_',
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    // const VerticalDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox.square(
                        dimension: MediaQuery.of(context).size.width / 2.4,
                        child: Center(
                          child: (proofGroups[i].afterImg != null)
                              ? Hero(
                                  tag: ValueKey(
                                    proofGroups[i].afterImg.toString(),
                                  ),
                                  child: GestureDetector(
                                    child: proofGroups[i].afterImg,
                                    onTap: () {
                                      unawaited(
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<XFile>(
                                            builder: (context) =>
                                                DisplayPictureScreen(
                                              image: proofGroups[i].afterImg!,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : FloatingActionButton(
                                  heroTag: ValueKey(i),
                                  child: const Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    final cameras = await availableCameras();
                                    // final firstCamera = cameras.first;
                                    if (!mounted) return;
                                    final defaultImgPath = await Navigator.push(
                                      context,
                                      MaterialPageRoute<XFile>(
                                        builder: (context) => TakePictureScreen(
                                          // Pass the appropriate camera to the TakePictureScreen widget.
                                          camera: cameras.first,
                                        ),
                                      ),
                                    );
                                    await proofList.addImage(
                                      i,
                                      defaultImgPath,
                                      'after_',
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
