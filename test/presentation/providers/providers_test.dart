import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:qr_scanner_workerbase/data/models/qr_code.dart';
import 'package:qr_scanner_workerbase/data/sources/hive_qrcode_source.dart';
import 'package:qr_scanner_workerbase/domain/repositories/qrcode_repository.dart';
import 'package:qr_scanner_workerbase/presentation/providers/providers.dart';
import 'package:qr_scanner_workerbase/presentation/viewmodels/history_viewmodel.dart';
import 'package:qr_scanner_workerbase/presentation/viewmodels/scanner_viewmodel.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late ProviderContainer container;
  late Box<QRCodeModel> mockBox;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QRCodeModelAdapter());
    }
    mockBox = await Hive.openBox<QRCodeModel>('testQrCodeBox');
    container = ProviderContainer(
      overrides: [
        hiveQrCodeSourceProvider
            .overrideWithValue(MockHiveQrCodeSource(mockBox)),
      ],
    );
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('hiveQrCodeSourceProvider provides a HiveQrCodeSource', () {
    final source = container.read(hiveQrCodeSourceProvider);
    expect(source, isA<HiveQRCodeSource>());
  });

  test('qrCodeRepositoryProvider provides a QrCodeRepository', () {
    final repository = container.read(qrCodeRepositoryProvider);
    expect(repository, isA<QrCodeRepository>());
  });

  test('historyViewModelProvider provides a HistoryViewModel', () {
    final viewModel = container.read(historyViewModelProvider.notifier);
    expect(viewModel, isA<HistoryViewModel>());
  });

  test('scannerViewModelProvider provides a ScannerViewModel', () {
    final viewModel = container.read(scannerViewModelProvider.notifier);
    expect(viewModel, isA<ScannerViewModel>());
  });
}

class MockHiveQrCodeSource extends HiveQRCodeSource {
  MockHiveQrCodeSource(super.box);

  @override
  Future<void> addQrCode(QRCodeModel code) async {}

  @override
  Future<void> deleteQrCodeByKey(int key) async {}

  @override
  Future<Map<int, QRCodeModel>> getAllQrCodesWithKeys() async {
    return {};
  }
}
