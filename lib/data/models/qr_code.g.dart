// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QRCodeModelAdapter extends TypeAdapter<QRCodeModel> {
  @override
  final int typeId = 0;

  @override
  QRCodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QRCodeModel(
      displayValue: fields[0] as String?,
      typeIndex: fields[1] as int,
      scannedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QRCodeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.displayValue)
      ..writeByte(1)
      ..write(obj.typeIndex)
      ..writeByte(2)
      ..write(obj.scannedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRCodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
