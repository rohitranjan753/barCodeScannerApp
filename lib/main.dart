import 'package:barcodescannerapp/provider/barcode_provider.dart';
import 'package:barcodescannerapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of my application.
// It is a ChangeNotifierProvider that provides the BarcodeProvider to all the widgets in the app.
// The BarcodeProvider is initialized with the loadBarcode method that loads the saved barCodeList from the shared preferences.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarcodeProvider()..loadBarcode(),
      child: MaterialApp(debugShowCheckedModeBanner: false,
       home: HomeScreen()),
    );
  }
}
