import 'package:hive/hive.dart';
import '../models/qr_code.dart';

class HiveBarcodeSource {
  final Box<QRCodeModel> _barcodeBox;

  HiveBarcodeSource(this._barcodeBox);

  Future<void> addBarcode(QRCodeModel barcode) async {
    await _barcodeBox.add(barcode);
  }

  Future<void> deleteBarcodeByKey(int key) async {
    await _barcodeBox.delete(key);
  }

  Future<List<QRCodeModel>> getAllBarcodes() async {
    return _barcodeBox.values.toList();
  }

  Future<Map<int, QRCodeModel>> getAllBarcodesWithKeys() async {
    return _barcodeBox.toMap().map((key, value) => MapEntry(key as int, value));
  }
}
