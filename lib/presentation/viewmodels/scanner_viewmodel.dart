import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/models/qr_code.dart';
import '../../domain/repositories/qrcode_repository.dart';
import '../providers/providers.dart';

class ScannerViewModel extends StateNotifier<ScannerState> {
  final MobileScannerController controller;
  final Ref ref;
  bool historyScreenShouldUpdateUI = false;
  final BarcodeRepository _repository;

  ScannerViewModel(this.controller, this.ref, this._repository)
      : super(ScannerState());

  void handleScannedBarcode(Barcode? barcode) {
    if (barcode != null) {
      state = state.copyWith(
        scannedData: barcode,
        isDialogVisible: true,
      );

      controller.stop(); // Stop scanning
    }
  }

  void saveScannedBarcode() {
    final scannedData = state.scannedData;
    if (scannedData != null) {
      final newBarcode = QRCodeModel(
        displayValue: scannedData.displayValue,
        typeIndex: scannedData.type.rawValue,
        scannedAt: DateTime.now(),
      );

      // Save to the repository
      _repository.addBarcode(newBarcode);

      historyScreenShouldUpdateUI = true;

      // Close the dialog and clear the scanned data
      closeDialog();
    }
  }

  void closeDialog() {
    state = state.copyWith(
      scannedData: null,
      isDialogVisible: false,
    );
    controller.start(); // Restart scanning
  }

  void finalizeSession() {
    // Notify history screen to update UI if new QR codes are added
    if (historyScreenShouldUpdateUI) {
      final historyNotifier = ref.read(historyViewModelProvider.notifier);
      historyNotifier.loadBarcodes();
      historyScreenShouldUpdateUI = false;
    }
  }
}

class ScannerState {
  final Barcode? scannedData;
  final bool isDialogVisible;

  ScannerState({
    this.scannedData,
    this.isDialogVisible = false,
  });

  ScannerState copyWith({
    Barcode? scannedData,
    bool? isDialogVisible,
  }) {
    return ScannerState(
      scannedData: scannedData ?? this.scannedData,
      isDialogVisible: isDialogVisible ?? this.isDialogVisible,
    );
  }
}
