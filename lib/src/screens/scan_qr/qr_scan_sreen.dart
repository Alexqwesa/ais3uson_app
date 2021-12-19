import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/worker_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final foundWidgetKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            child: Column(
              children: <Widget>[
                if (result == null)
                  const Expanded(
                    child: Text('Выполняется поиск Qr-кода...'),
                  )
                else
                  Column(
                    children: [
                      Text(
                        ' Данные: ${result!.code}',
                        softWrap: true,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blue[900]!,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  result = null;
                                });
                                await controller?.resumeCamera();
                              },
                              child: const Text(
                                'Повторить поиск',
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(),
                          ),
                          // if (result!.code!.contains("http://{ "))
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.green,
                                ),
                              ),
                              onPressed: () async {
                                if (result == null) {
                                  return;
                                }
                                final newKey = result!.code!
                                    .substring(7, result!.code!.length);
                                final res = await AppData().addProfileFromUKey(
                                  WorkerKey.fromJson(json.decode(newKey)),
                                );
                                if (!mounted) return;
                                if (res) {
                                  // Navigator.of(context).pop();
                                  await Navigator.of(context).pushNamed('/');
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text(
                                      'Ошибка добавления отделения, возможно отделение уже было добавлено',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }

                                setState(() {
                                  result = null;
                                  controller!.resumeCamera();
                                });
                              },
                              child: const Text(
                                'Добавить!',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Text('Вспышка: ${snapshot.data}');
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            return snapshot.data != null
                                ? describeEnum(snapshot.data!) == 'front'
                                    ? const Text('Фронтал. камера')
                                    : const Text('Тыловая камера')
                                : const Text('Загрузка');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width * 0.9;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 5,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (describeEnum(result!.format) == 'qrcode' ||
          result!.code!.startsWith('http://{"app": "AIS-3USON web"')) {
        controller.pauseCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    dev.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет доступа, разрешите приложению доступ к камере')),
      );
    }
  }
}
