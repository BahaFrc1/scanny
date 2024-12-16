import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:qr_scanner_workerbase/data/models/qr_code.dart';
import 'package:qr_scanner_workerbase/data/repositories/qrcode_repository.dart';
import 'package:qr_scanner_workerbase/data/sources/hive_qrcode_source.dart';

void main() {
  late QrCodeRepositoryImpl qrCodeRepository;
  late HiveQRCodeSource hiveQRCodeSource;
  late Box<QRCodeModel> qrCodeBox;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QRCodeModelAdapter());
    }    qrCodeBox = await Hive.openBox<QRCodeModel>('testQrCodeBox');
    hiveQRCodeSource = HiveQRCodeSource(qrCodeBox);
    qrCodeRepository = QrCodeRepositoryImpl(hiveQRCodeSource);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('QrCodeRepositoryImpl', () {
    test('addQrCode should add a code to the box', () async {
      final qrCode = QRCodeModel(
        displayValue: 'testCode',
        typeIndex: 0,
        scannedAt: DateTime.now(),
      );
      await qrCodeRepository.addQrCode(qrCode);

      final qrCodes = qrCodeBox.values.toList();
      expect(qrCodes.length, 1);
      expect(qrCodes.first.displayValue, 'testCode');
    });

    test('deleteQrCodeByKey should delete a qrCode by key', () async {
      final qrCodes = QRCodeModel(
        displayValue: 'testCode',
        typeIndex: 0,
        scannedAt: DateTime.now(),
      );
      await qrCodeBox.add(qrCodes);
      final key = qrCodeBox.keys.first;

      await qrCodeRepository.deleteQrCodeByKey(key);

      final codesList = qrCodeBox.values.toList();
      expect(codesList.length, 0);
    });

    test('getAllQrCodesWithKeys should return all qrCodes with keys',
            () async {
          final qrCode1 = QRCodeModel(
            displayValue: 'testCode1',
            typeIndex: 0,
            scannedAt: DateTime.now(),
          );
          final qrCode2 = QRCodeModel(
            displayValue: 'testCode2',
            typeIndex: 0,
            scannedAt: DateTime.now(),
          );
          await qrCodeBox.addAll([qrCode1, qrCode2]);

          final qrCodesWithKeys = await qrCodeRepository.getAllQrCodesWithKeys();
          expect(qrCodesWithKeys.length, 2);
          expect(qrCodesWithKeys.values.first.displayValue, 'testCode1');
          expect(qrCodesWithKeys.values.last.displayValue, 'testCode2');
        });
  });
}
