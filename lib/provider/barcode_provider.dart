import 'package:barcodescannerapp/model/barcode_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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