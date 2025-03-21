import 'package:barcodescannerapp/provider/barcode_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScannerScreen extends StatelessWidget {
  final MobileScannerController scannerController = MobileScannerController();

  ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barcodeProvider = Provider.of<BarcodeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Scan Barcode')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  barcodeProvider.setBarcode(barcodes.first.rawValue!);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Scanned Barcode: ${barcodeProvider.barcode}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          ElevatedButton(onPressed: (){
            if(barcodeProvider.barcode.isNotEmpty){
              barcodeProvider.addBarcode(barcodeProvider.barcode);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No barcode scanned')));
            }
          }, child: Text('Save'))

        ],
      ),
    );
  }
}