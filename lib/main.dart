import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MyApp());
}

class BarCodeModel{
  final String barcode;
  final String date;
  BarCodeModel(this.barcode, this.date);
}

class BarcodeProvider extends ChangeNotifier {
    List<BarCodeModel> _barcodes = [];

  List<BarCodeModel> get barcodes => _barcodes;

  Future<void> addBarcode(String value) async {
    _barcodes.add(BarCodeModel(value, DateTime.now().toString()));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('barcodes', _barcodes.map((e) => e.barcode).toList());
  }

  Future<void> removeBarcode(int index) async {
    _barcodes.removeAt(index);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('barcodes', _barcodes.map((e) => e.barcode).toList());
  }



  String _barcode = "";

  String get barcode => _barcode;

  Future<void> setBarcode(String value) async {
    _barcode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('barcode', value);
  }

  Future<void> loadBarcode() async {
    final prefs = await SharedPreferences.getInstance();
    _barcodes = (prefs.getStringList('barcodes') ?? []).map((e) => BarCodeModel(e, DateTime.now().toString())).toList();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarcodeProvider()..loadBarcode(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {

  //date utinity fucntion, show day, month and year
  String getDate(String date){
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barcode Scanner')),
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
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(provider.barcodes[index].barcode),
                        subtitle: Text("Date: ${getDate(provider.barcodes[index].date)}"),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy),
                                onPressed: () {
                                  final data = provider.barcodes[index];
                                  Clipboard.setData(ClipboardData(text: data.barcode));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
                              
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerScreen()),
                );
              },
              child: Text('Scan Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController scannerController = MobileScannerController();

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
            if(barcodeProvider._barcode.isNotEmpty){
              barcodeProvider.addBarcode(barcodeProvider._barcode);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No barcode scanned')));
            }
          }, child: Text('Save'))

        ],
      ),
    );
  }
}
