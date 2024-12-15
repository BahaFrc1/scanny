import '../../data/models/qr_code.dart';

abstract class BarcodeRepository {
  Future<Map<int, QRCodeModel>> getAllBarcodesWithKeys();
  Future<void> addBarcode(QRCodeModel barcode);
  Future<void> deleteBarcodeByKey(int key);
}