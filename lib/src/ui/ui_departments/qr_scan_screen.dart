import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// Show screen where user scan QR code to add [Worker] from QR code.
///
/// {@category UI Workers}
class QRScanScreen extends ConsumerStatefulWidget {
  const QRScanScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends ConsumerState<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final foundWidgetKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null || result!.code != null) {
        var newKey = result!.code!;
        newKey = newKey.startsWith('http://')
            ? newKey.substring(7, newKey.length)
            : newKey;
        if (describeEnum(newKey) == 'qrcode' ||
            newKey.startsWith('{"app": "AIS-3USON web"')) {
          controller.pauseCamera();
          dev.log(newKey);
        }
      }
    });
  }

  // In order to get hot reload to work we need to
  // pause the camera if the platform is android,
  // or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr().doScanQrCode),
      ),
      body: Column(
        children: <Widget>[
          //
          // > camera widget
          //
          Expanded(
            flex: 4,
            child: ShowQrView(
              qrKey: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          //
          // > returned text
          //
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Center(
                child: (result == null)
                    ? Text(tr().searchQR)
                    : Text(
                        '${tr().data}${result!.code}',
                        softWrap: true,
                      ),
              ),
            ),
          ),
          Row(
            children: [
              //
              // > rerun search button
              //
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: result != null,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue[900]!,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            result = null;
                          });
                          await controller?.resumeCamera();
                        },
                        child: Text(
                          tr().repeatSearch,
                        ),
                      ),
                    ),
                  ),
                  //
                  // > additional camera control
                  //
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return ColorFiltered(
                              colorFilter: snapshot.data != null
                                  ? const ColorFilter.matrix(
                                      <double>[
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0, 0, 0, 1, 0,
                                      ],
                                    )
                                  : ColorFilter.mode(
                                      Colors.white.withOpacity(1),
                                      BlendMode.lighten,
                                    ),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller?.toggleFlash();
                                  setState(() {
                                    // ignore: unused_local_variable
                                    int doNothing;
                                  });
                                },
                                child: Text(tr().flashLight),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {
                              // ignore: unused_local_variable
                              int doNothing;
                            });
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              return snapshot.data != null
                                  ? describeEnum(snapshot.data!) == 'front'
                                      ? const Icon(Icons.cameraswitch)
                                      : const Icon(Icons.cameraswitch_outlined)
                                  : Text(tr().loading);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //
              // > add department
              //
              Visibility(
                visible: result != null,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                      ),
                      //
                      // > add new worker profile
                      //
                      onPressed: () async {
                        if (result == null) {
                          return;
                        }
                        var newKey = result!.code!;
                        newKey = newKey.startsWith('http://')
                            ? newKey.substring(7, newKey.length)
                            : newKey;
                        //
                        // > add profile or resume camera
                        //
                        if (await addNewWProfile(context, ref, newKey)) {
                          if (context.mounted) context.pop();
                        } else {
                          setState(
                            () {
                              result = null;
                              controller!.resumeCamera();
                            },
                          );
                        }
                      },
                      child: Text(
                        tr().add,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowQrView extends StatelessWidget {
  const ShowQrView({
    required this.qrKey,
    required this.onQRViewCreated,
    super.key,
  });

  final GlobalKey qrKey;
  final void Function(QRViewController) onQRViewCreated;

  void _onPermissionSet(BuildContext context, QRViewController _, bool p) {
    dev.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr().cameraAccessDenied),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is
    // and change the scanArea and overlay accordingly.
    final scanArea = MediaQuery.of(context).size.width * 0.9;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification
    // and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        // borderColor: Colors.red,
        borderRadius: 5,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }
}
