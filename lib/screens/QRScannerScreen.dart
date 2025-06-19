import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedData;

  @override
  Widget build(BuildContext context) {
    // ✅ Mostrar aviso si está en Web
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Escáner QR')),
        body: const Center(
          child: Text('El escaneo QR no es compatible con Flutter Web.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Escáner QR')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Escanea un código QR", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          SizedBox(
            height: 400,
            child: MobileScanner(
              controller: MobileScannerController(),
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final String? code = barcode.rawValue;

                if (code != null && scannedData == null) {
                  setState(() {
                    scannedData = code;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Código escaneado: $code')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          if (scannedData != null)
            Column(
              children: [
                Text('Resultado: $scannedData'),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => _abrirUrl(scannedData!),
                  child: const Text("Ir al sitio"),
                ),
              ],
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL no válida')),
      );
    }
  }
}
