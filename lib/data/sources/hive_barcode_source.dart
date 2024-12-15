import 'package:hive/hive.dart';
import '../models/qr_code.dart';

class HiveBarcodeSource {
  final Box<QRCodeModel> _barcodeBox;

  HiveBarcodeSource(this._barcodeBox);

  Future<void> addBarcode(QRCodeModel barcode) async {
    await _barcodeBox.add(barcode); // Adds new barcode with an auto-generated key
  }

  Future<void> deleteBarcodeByKey(int key) async {
    await _barcodeBox.delete(key); // Deletes barcode using the Hive key (int)
  }

  Future<List<QRCodeModel>> getAllBarcodes() async {
    return _barcodeBox.values.toList(); // Returns all barcodes
  }

  Future<Map<int, QRCodeModel>> getAllBarcodesWithKeys() async {
    return _barcodeBox.toMap().map((key, value) => MapEntry(key as int, value));
  }
}
