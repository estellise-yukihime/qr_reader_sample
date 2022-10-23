import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _qrKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() async {
    super.reassemble();

    // for Hot Reload only?
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }

    await controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Reader Sample'),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(result != null ? result!.code! : 'Content of the QR in here'),
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: 200,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: (controller) {
                  setState(() {
                    this.controller = controller;
                  });
                  controller.scannedDataStream.listen((event) {
                    setState(() {
                      result = event;

                      print(result);
                    });
                  });
                },
                overlay: QrScannerOverlayShape(),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller != null) {
            await controller!.resumeCamera();
          }
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
