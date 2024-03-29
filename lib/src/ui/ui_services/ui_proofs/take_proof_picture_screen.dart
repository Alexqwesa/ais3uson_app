import 'dart:developer' as dev;

import 'package:ais3uson_app/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A screen that allows users to take a picture using a given camera.
///
/// Used to make proof images.
///
/// {@category UI Proofs}
class TakeProofPictureScreen extends StatefulWidget {
  const TakeProofPictureScreen({
    required this.camera,
    super.key,
  });

  final CameraDescription camera;

  @override
  State<TakeProofPictureScreen> createState() => _TakeProofPictureScreenState();
}

class _TakeProofPictureScreenState extends State<TakeProofPictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.veryHigh, // todo: setup it in settings
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr().takePicture)),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until
      // the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? CameraPreview(_controller)
              : const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: 1.3,
            child: FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();

                  // If the picture was taken, return it.
                  if (!mounted) return;
                  Navigator.pop(context, image);
                  // ignore: avoid_catches_without_on_clauses
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  dev.log(e.toString());
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays the picture taken by the worker as proof of work.
///
/// {@category UI Proofs}
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({
    required this.image,
    super.key,
  });

  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MaterialLocalizations.of(context).backButtonTooltip),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Hero(
          tag: ValueKey(image.toString()),
          child: FittedBox(
            fit: BoxFit.cover,
            child: InteractiveViewer(child: image),
          ),
        ),
      ),
    );
  }
}
