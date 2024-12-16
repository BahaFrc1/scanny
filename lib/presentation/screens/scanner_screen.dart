import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../config/keys.dart';
import '../providers/providers.dart';
import '../widgets/scanner_dialog.dart';
import '../widgets/scanner_error.dart';
import '../widgets/scanner_overlay_painter.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  bool _isSingleQRScanner = false;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(scannerControllerProvider);

    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen((data) {
          if (data.barcodes.isNotEmpty) {
            ref
                .read(scannerViewModelProvider.notifier)
                .handleScannedQrCode(data.barcodes.first);
          }
        });
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
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
          title: const Text(appBarTitleScanner),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                context.go(routeHistory);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // QR Code Scanner View
            MobileScanner(
              controller: controller,
              onDetect: (code) {
                if (code.barcodes.isNotEmpty) {
                  scannerViewModel.handleScannedQrCode(code.barcodes.first);
                }
              },
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              fit: BoxFit.cover,
            ),

            if (!scannerState.isDialogVisible)
              // QR Scanner Overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: ScannerOverlayPainter(),
                ),
              ),

            if (!scannerState.isDialogVisible)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flashlight_on,
                            color: Colors.white),
                        onPressed: () => controller.toggleTorch(),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.cameraswitch, color: Colors.white),
                        onPressed: () => controller.switchCamera(),
                      ),
                    ],
                  ),
                ),
              ),

            // Show dialog when a QR code is detected
            if (scannerState.isDialogVisible)
              newCodeScannedDialog(context, scannerState.scannedData?.displayValue, onSave: () {
                scannerViewModel.saveScannedQrCode();
                if (_isSingleQRScanner) {
                  scannerViewModel.finalizeSession();
                  context.go(routeHistory);
                }
              }, onCancel: () {
                scannerViewModel.closeDialog();
              }),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    await ref.read(scannerControllerProvider).dispose();
    super.dispose();
  }
}
