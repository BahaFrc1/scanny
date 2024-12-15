import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers.dart';

class ScannerScreen extends ConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannerState = ref.watch(scannerViewModelProvider);
    final scannerViewModel = ref.read(scannerViewModelProvider.notifier);
    final controller = ref.read(scannerControllerProvider);

    return PopScope(
      onPopInvokedWithResult: (pop, res) {
        scannerViewModel.finalizeSession();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scanner'),
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
              fit: BoxFit.contain,
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
