import 'package:barcodescannerapp/provider/barcode_provider.dart';
import 'package:barcodescannerapp/screens/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //date utility fucntion, show day, month and year
  String getDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Consumer<BarcodeProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.barcodes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            provider.barcodes[index].barcode,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Date: ${getDate(provider.barcodes[index].date)}",
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    final data = provider.barcodes[index];
                                    Clipboard.setData(
                                      ClipboardData(text: data.barcode),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied to clipboard'),
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
        
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScannerScreen()),
          );
        },
        child: SizedBox(
          width: 100,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text('Scan Barcode'), Icon(Icons.camera_alt)],
          ),
        ),
      ),
    );
  }
}
