import 'package:barcodescannerapp/constant/text_constant.dart';
import 'package:barcodescannerapp/provider/barcode_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

// This widget is used to scan the barcode using the camera.
// When the user jumps to this screen, the camera will be opened, and the user can scan the barcode.
// The barcode will be displayed on the screen, and the user can save it by pressing the save button.
class ScannerScreen extends StatelessWidget {
  final MobileScannerController scannerController = MobileScannerController();

  ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barcodeProvider = Provider.of<BarcodeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.shade100,
        title: Text(TextConstant.barCodeScannerTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This widget is used to scan the barcode using the camera.
          // It is a MobileScanner widget that scans the barcode and returns the barcode value.
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
          barcodeProvider.barcode.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${TextConstant.scannedBarcode}${barcodeProvider.barcode}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
              : SizedBox(),

          // This widget is used to save the scanned barcode.
          // It is an ElevatedButton that saves the barcode to the shared preferences when pressed.
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  try {
                    if (barcodeProvider.barcode.isNotEmpty) {
                      barcodeProvider.addBarcode(barcodeProvider.barcode);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(TextConstant.barcodeSaved),duration: Durations.long1,),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(TextConstant.noBarcodeScanned)),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Row(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text(TextConstant.save), Icon(Icons.save)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
