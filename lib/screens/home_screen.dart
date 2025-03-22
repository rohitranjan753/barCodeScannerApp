import 'package:barcodescannerapp/constant/text_constant.dart';
import 'package:barcodescannerapp/provider/barcode_provider.dart';
import 'package:barcodescannerapp/screens/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This method is used to format the date in the format dd/mm/yyyy.
  // It takes a date string as an argument and returns a formatted date string.
  String getDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(TextConstant.barCodeScannerTitle),
      ),
      body: Center(
        child: Column(
          children: [
            // This widget is used to display the list of scanned barCodeList.
            // It is a ListView.builder that displays the barcode and the date it was scanned.
            Expanded(
              child: Consumer<BarcodeProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.barCodeList.length,
                    itemBuilder: (context, index) {
                      return Container(

                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 226, 255),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            provider.barCodeList[index].barcode,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            "${TextConstant.date}${getDate(provider.barCodeList[index].date)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  final data = provider.barCodeList[index];
                                  Clipboard.setData(
                                    ClipboardData(text: data.barcode),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        TextConstant.copiedToClipboard,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  provider.removeBarcode(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // This widget is used to navigate to the ScannerScreen.
      // When pressed on it, it will take the user to the ScannerScreen.
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScannerScreen(),),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(TextConstant.scanBarcode), Icon(Icons.camera_alt)],
        ),
      ),
    );
  }
}
