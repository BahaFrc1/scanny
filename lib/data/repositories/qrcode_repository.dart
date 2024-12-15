import 'package:hive/hive.dart';

import '../../domain/repositories/qrcode_repository.dart';
import '../models/qr_code.dart';
import '../sources/hive_barcode_source.dart';

class BarcodeRepositoryImpl implements BarcodeRepository {
  final HiveBarcodeSource _hiveSource;

  BarcodeRepositoryImpl(this._hiveSource);

  @override
  Future<void> addBarcode(QRCodeModel barcode) async {
  await _hiveSource.addBarcode(barcode);
  }

  @override
  Future<void> deleteBarcodeByKey(int key) async {
  await _hiveSource.deleteBarcodeByKey(key);
  }

  @override
  Future<Map<int, QRCodeModel>> getAllBarcodesWithKeys() async {
  return _hiveSource.getAllBarcodesWithKeys();
  }
}
