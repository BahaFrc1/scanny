import 'package:hive/hive.dart';
import '../models/qr_code.dart';

class HiveQRCodeSource {
  final Box<QRCodeModel> _qrcodeBox;

  HiveQRCodeSource(this._qrcodeBox);

  Future<void> addQrCode(QRCodeModel code) async {
    await _qrcodeBox.add(code);
  }

  Future<void> deleteQrCodeByKey(int key) async {
    await _qrcodeBox.delete(key);
  }

  Future<List<QRCodeModel>> getAllQrCodes() async {
    return _qrcodeBox.values.toList();
  }

  Future<Map<int, QRCodeModel>> getAllQrCodesWithKeys() async {
    return _qrcodeBox.toMap().map((key, value) => MapEntry(key as int, value));
  }
}
