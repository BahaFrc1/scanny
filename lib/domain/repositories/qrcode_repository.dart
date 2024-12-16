import '../../data/models/qr_code.dart';

abstract class QrCodeRepository {
  Future<Map<int, QRCodeModel>> getAllQrCodesWithKeys();

  Future<void> addQrCode(QRCodeModel code);

  Future<void> deleteQrCodeByKey(int key);
}
