import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/qrcode_repository.dart';
import '../../data/models/qr_code.dart';

class HistoryViewModel extends StateNotifier<List<MapEntry<int, QRCodeModel>>> {
  final BarcodeRepository _repository;
  HistoryViewModel(this._repository) : super([]) {
    loadBarcodes();
  }

  /// Loads the history of scanned QR codes from the local Hive database
  Future<void> loadBarcodes() async {
    final codes = (await _repository.getAllBarcodesWithKeys()).entries.toList();
    codes.sort((a, b) => b.value.scannedAt.compareTo(a.value.scannedAt));
    state = codes;
  }

  /// Delete a scanned QR code
  Future<void> deleteBarcode(int key) async {
    await _repository.deleteBarcodeByKey(key);
    await loadBarcodes();
  }
}
