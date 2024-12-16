import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_scanner_workerbase/data/models/qr_code.dart';
import 'package:qr_scanner_workerbase/domain/repositories/qrcode_repository.dart';
import 'package:qr_scanner_workerbase/presentation/providers/providers.dart';
import 'package:qr_scanner_workerbase/presentation/viewmodels/history_viewmodel.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mockito/annotations.dart';

import 'history_view_model_test.mocks.dart';

@GenerateMocks([QrCodeRepository])
void main() {
  late MockQrCodeRepository mockRepository;
  late ProviderContainer container;
  late HistoryViewModel viewModel;

  setUp(() {
    mockRepository = MockQrCodeRepository();
    container = ProviderContainer(
      overrides: [
        qrCodeRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    viewModel = HistoryViewModel(mockRepository);
  });

  tearDown(() {
    container.dispose();
  });

  test('loadQrCode should load and sort qrCode', () async {
    // Arrange
    final qrCodes = {
      1: QRCodeModel(
          displayValue: 'code1', typeIndex: 0, scannedAt: DateTime(2022, 1, 1)),
      2: QRCodeModel(
          displayValue: 'code2', typeIndex: 0, scannedAt: DateTime(2022, 1, 2)),
    };
    when(mockRepository.getAllQrCodesWithKeys()).thenAnswer((_) async => qrCodes);

    // Act
    await viewModel.loadQrCodes();

    // Assert
    expect(viewModel.state.length, 2);
    expect(viewModel.state[0].key, 2); // Sorted by date descending
    expect(viewModel.state[1].key, 1);
  });

  test('deleteQrCode should delete a qrCode and reload qrCodes', () async {
    // Arrange
    final qrCodes = {
      1: QRCodeModel(
          displayValue: 'code1', typeIndex: 0, scannedAt: DateTime(2022, 1, 1)),
    };
    when(mockRepository.getAllQrCodesWithKeys())
        .thenAnswer((_) async => qrCodes);
    when(mockRepository.deleteQrCodeByKey(1))
        .thenAnswer((_) async => Future.value());

    // Act
    await viewModel.loadQrCodes();
    await viewModel.deleteQrCode(1);

    // Assert
    verify(mockRepository.deleteQrCodeByKey(1)).called(1);
    expect(viewModel.state.length, 0);
  });
}
