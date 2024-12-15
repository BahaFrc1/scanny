import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';

IconData getBarcodeIcon(int typeIndex) {
  switch (BarcodeType.fromRawValue(typeIndex)) {
    case BarcodeType.contactInfo:
      return Icons.contact_page;
    case BarcodeType.email:
      return Icons.email;
    case BarcodeType.isbn:
      return Icons.book;
    case BarcodeType.phone:
      return Icons.phone;
    case BarcodeType.product:
      return Icons.shopping_cart;
    case BarcodeType.sms:
      return Icons.sms;
    case BarcodeType.text:
      return Icons.text_fields;
    case BarcodeType.url:
      return Icons.link;
    case BarcodeType.wifi:
      return Icons.wifi;
    case BarcodeType.geo:
      return Icons.map;
    case BarcodeType.calendarEvent:
      return Icons.event;
    case BarcodeType.driverLicense:
      return Icons.badge;
    default:
      return Icons.qr_code;
  }
}

Future<void> shareContent(String text) async {
  Share.share(text);
}