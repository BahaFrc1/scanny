import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_scanner_workerbase/data/models/qr_code.dart';
import 'package:qr_scanner_workerbase/data/sources/hive_barcode_source.dart';

// Mock class for Hive Box
class MockHiveBox extends Mock implements Box<QRCodeModel> {}

void main() {
  group('HiveBarcodeSource Tests', () {
    late MockHiveBox mockBox;
    late HiveBarcodeSource hiveBarcodeSource;

    setUp(() {
      mockBox = MockHiveBox();
      hiveBarcodeSource = HiveBarcodeSource(mockBox);
    });

    test('addBarcode adds a barcode to the box', () async {
      final barcode = QRCodeModel(typeIndex: 0, displayValue: 'Test QR Code', scannedAt: DateTime.now());

      when(mockBox.add(barcode)).thenAnswer((_) async => 0);

      await hiveBarcodeSource.addBarcode(barcode);

      verify(mockBox.add(barcode)).called(1);
    });

    test('deleteBarcodeByKey deletes a barcode by key', () async {
      const key = 1;

      when(mockBox.delete(key)).thenAnswer((_) async => Future.value());

      await hiveBarcodeSource.deleteBarcodeByKey(key);

      verify(mockBox.delete(key)).called(1);
    });

    test('getAllBarcodes returns a list of all barcodes', () async {
      final barcodes = [
        QRCodeModel(typeIndex: 0, displayValue: 'Test QR Code 1', scannedAt: DateTime.now()),
        QRCodeModel(typeIndex: 0, displayValue: 'Test QR Code 2', scannedAt: DateTime.now())
      ];

      when(mockBox.values).thenReturn(barcodes);

      final result = await hiveBarcodeSource.getAllBarcodes();

      expect(result, barcodes);
      verify(mockBox.values).called(1);
    });

    test('getAllBarcodesWithKeys returns a map of all barcodes with keys', () async {
      final barcodes = {
        1: QRCodeModel(typeIndex: 0, displayValue: 'Test QR Code 1', scannedAt: DateTime.now()),
        2: QRCodeModel(typeIndex: 0, displayValue: 'Test QR Code 2', scannedAt: DateTime.now())
      };

      when(mockBox.toMap()).thenReturn(barcodes);

      final result = await hiveBarcodeSource.getAllBarcodesWithKeys();

      expect(result, barcodes);
      verify(mockBox.toMap()).called(1);
    });
  });
}
