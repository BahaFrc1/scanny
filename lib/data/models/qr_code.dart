import 'package:hive/hive.dart';

part 'qr_code.g.dart';

@HiveType(typeId: 0)
class QRCodeModel {
  @HiveField(0)
  final String? displayValue;
  @HiveField(1)
  final int typeIndex;
  @HiveField(2)
  final DateTime scannedAt;

  QRCodeModel({
    required this.displayValue,
    required this.typeIndex,
    required this.scannedAt,
  });
}
