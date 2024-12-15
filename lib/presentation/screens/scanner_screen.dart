import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/providers.dart';
import '../widgets/scanner_overlay_painter.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  bool _isSingleQRScanner = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final preferencesRepository = ref.read(preferencesRepositoryProvider);
    final isSingleQRScanner = await preferencesRepository.getSingleQRScanner();
    setState(() {
      _isSingleQRScanner = isSingleQRScanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(scannerViewModelProvider);
    final scannerViewModel = ref.read(scannerViewModelProvider.notifier);
    final controller = ref.read(scannerControllerProvider);

    return PopScope(
      onPopInvokedWithResult: (pop, res) {
        scannerViewModel.finalizeSession();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scanner', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // QR Code Scanner View
            MobileScanner(
              controller: controller,
              onDetect: (barcode) {
                if (barcode.barcodes.isNotEmpty) {
                  scannerViewModel.handleScannedBarcode(barcode.barcodes.first);
                }
              },
              fit: BoxFit.cover,
            ),

            // QR Scanner Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerOverlayPainter(),
              ),
            ),

            // Bottom action buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.flashlight_on, color: Colors.white),
                      onPressed: () => controller.toggleTorch(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, color: Colors.white),
                      onPressed: () => controller.switchCamera(),
                    ),
                  ],
                ),
              ),
            ),

            // Show dialog when a QR code is detected
            if (scannerState.isDialogVisible)
              AlertDialog(
                title: const Text('Scanned QR Code'),
                content: Text(scannerState.scannedData?.displayValue ??
                    'Unknown QR Code'),
                actions: [
                  TextButton(
                    onPressed: () {
                      scannerViewModel.closeDialog();
                      scannerViewModel.saveScannedBarcode();
                      if (_isSingleQRScanner) {
                        scannerViewModel.finalizeSession();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      scannerViewModel.closeDialog();
                    },
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
