import 'package:barcodescannerapp/model/barcode_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeProvider extends ChangeNotifier {
    List<BarCodeModel> _barCodeList = [];

  List<BarCodeModel> get barCodeList => _barCodeList;

  Future<void> addBarcode(String value) async {
    _barCodeList.add(BarCodeModel(value, DateTime.now().toString()));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('barCodeList', _barCodeList.map((e) => e.barcode).toList());
  }

  Future<void> removeBarcode(int index) async {
    _barCodeList.removeAt(index);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('barCodeList', _barCodeList.map((e) => e.barcode).toList());
  }



  String _barCodeStringValue = "";

  String get barcode => _barCodeStringValue;

  Future<void> setBarcode(String value) async {
    _barCodeStringValue = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('barcode', value);
  }

  Future<void> loadBarcode() async {
    final prefs = await SharedPreferences.getInstance();
    _barCodeList = (prefs.getStringList('barCodeList') ?? []).map((e) => BarCodeModel(e, DateTime.now().toString())).toList();
    notifyListeners();
  }
}