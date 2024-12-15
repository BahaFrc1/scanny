
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/models/qr_code.dart';
import '../data/repositories/qrcode_repository.dart';
import '../data/sources/hive_barcode_source.dart';
import '../domain/repositories/qrcode_repository.dart';
import 'viewmodels/history_viewmodel.dart';
import 'viewmodels/scanner_viewmodel.dart';

final hiveBarcodeSourceProvider = Provider<HiveBarcodeSource>((ref) {
  final box = Hive.box<QRCodeModel>('barcodeHistory');
  return HiveBarcodeSource(box);
});

final barcodeRepositoryProvider = Provider<BarcodeRepository>((ref) {
  final source = ref.read(hiveBarcodeSourceProvider);
  return BarcodeRepositoryImpl(source);
});

final historyViewModelProvider =
StateNotifierProvider<HistoryViewModel, List<MapEntry<int, QRCodeModel>>>((ref) {
  final repository = ref.read(barcodeRepositoryProvider);
  return HistoryViewModel(repository);
});

final scannerControllerProvider = Provider<MobileScannerController>(
      (ref) => MobileScannerController(
    autoStart: true,
    torchEnabled: false,
    useNewCameraSelector: true,
  ),
);

final scannerViewModelProvider =
StateNotifierProvider<ScannerViewModel, ScannerState>(
      (ref) {
    final controller = ref.read(scannerControllerProvider);
    final repository = ref.read(barcodeRepositoryProvider); // Ensure repository is provided
    return ScannerViewModel(controller, ref, repository);
  },
);