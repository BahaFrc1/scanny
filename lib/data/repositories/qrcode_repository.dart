import 'package:hive/hive.dart';

import '../../domain/repositories/qrcode_repository.dart';
import '../models/qr_code.dart';
import '../sources/hive_qrcode_source.dart';

class QrCodeRepositoryImpl implements QrCodeRepository {
  final HiveQRCodeSource _hiveSource;

  QrCodeRepositoryImpl(this._hiveSource);

  @override
  Future<void> addQrCode(QRCodeModel code) async {
  await _hiveSource.addQrCode(code);
  }

  @override
  Future<void> deleteQrCodeByKey(int key) async {
  await _hiveSource.deleteQrCodeByKey(key);
  }

  @override
  Future<Map<int, QRCodeModel>> getAllQrCodesWithKeys() async {
  return _hiveSource.getAllQrCodesWithKeys();
  }
}
