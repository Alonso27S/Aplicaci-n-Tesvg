import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'result_page.dart';

class ScannerPage extends StatefulWidget {

  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() =>
      _ScannerPageState();
}

class _ScannerPageState
    extends State<ScannerPage> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Escanear Credencial",
        ),
      ),

      body: MobileScanner(

        onDetect: (capture) {

          if (scanned) return;

          final barcode =
              capture.barcodes.first;

          final qr =
              barcode.rawValue ?? "";

          print("================================");
          print("QR ESCANEADO:");
          print(qr);
          print("LONGITUD:");
          print(qr.length);
          print("================================");

          scanned = true;

          Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  ResultPage(
                qrData: qr,
              ),
            ),
          ).then((_) {

            scanned = false;
          });
        },
      ),
    );
  }
}