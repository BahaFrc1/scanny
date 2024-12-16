import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:qr_scanner_workerbase/data/models/qr_code.dart';
import 'package:qr_scanner_workerbase/data/sources/hive_qrcode_source.dart';

void main() {
  late HiveQRCodeSource hiveQRCodeSource;
  late Box<QRCodeModel> qrCodeBox;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QRCodeModelAdapter());
    }
    qrCodeBox = await Hive.openBox<QRCodeModel>('testQrCodeBox');
    hiveQRCodeSource = HiveQRCodeSource(qrCodeBox);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('HiveQrCodeSource', () {
    test('addQrCode should add a qrCode to the box', () async {
      final qrCode = QRCodeModel(
        displayValue: 'testCode',
        typeIndex: 0,
        scannedAt: DateTime.now(),
      );
      await hiveQRCodeSource.addQrCode(qrCode);

      final qrCodes = qrCodeBox.values.toList();
      expect(qrCodes.length, 1);
      expect(qrCodes.first.displayValue, 'testCode');
    });

    test('deleteQrCodeByKey should delete a qrCode by key', () async {
      final qrCode = QRCodeModel(
        displayValue: 'testCode',
        typeIndex: 0,
        scannedAt: DateTime.now(),
      );
      await qrCodeBox.add(qrCode);
      final key = qrCodeBox.keys.first;

      await hiveQRCodeSource.deleteQrCodeByKey(key);

      final qrCodes = qrCodeBox.values.toList();
      expect(qrCodes.length, 0);
    });

    test('getAllQrCode should return all qrCode', () async {
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

      final qrCodes = await hiveQRCodeSource.getAllQrCodes();
      expect(qrCodes.length, 2);
      expect(qrCodes[0].displayValue, 'testCode1');
      expect(qrCodes[1].displayValue, 'testCode2');
    });

    test('getAllQrCodeWithKeys should return all qrCode with keys', () async {
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

      final qrCodesWithKeys = await hiveQRCodeSource.getAllQrCodesWithKeys();
      expect(qrCodesWithKeys.length, 2);
      expect(qrCodesWithKeys.values.first.displayValue, 'testCode1');
      expect(qrCodesWithKeys.values.last.displayValue, 'testCode2');
    });
  });
}