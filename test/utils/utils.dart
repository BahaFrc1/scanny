import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_workerbase/utils/converter.dart';
import 'package:qr_scanner_workerbase/utils/scanner_utils.dart';

void main() {
  group('formatDate Tests', () {
    test('formats DateTime correctly', () {
      final date = DateTime(2023, 12, 15, 22, 47);
      final expectedFormattedDate = 'Dec 15, 2023, 10:47 PM';
      final result = formatDate(date);
      expect(result, expectedFormattedDate);
    });
  });

  group('getQrCodeIcon Tests', () {
    test('returns correct icon for contactInfo', () {
      expect(getQRCodeIcon(BarcodeType.contactInfo.rawValue), Icons.contact_page);
    });
    test('returns correct icon for email', () {
      expect(getQRCodeIcon(BarcodeType.email.rawValue), Icons.email);
    });
    test('returns correct icon for ISBN', () {
      expect(getQRCodeIcon(BarcodeType.isbn.rawValue), Icons.book);
    });
    test('returns default icon for unknown type', () {
      expect(getQRCodeIcon(-1), Icons.qr_code);
    });
  });
}
