import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../utils/converter.dart';
import '../providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: history.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.history, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No scanned QR codes yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final entry = history[index];
          final key = entry.key;
          final barcode = entry.value;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                barcode.displayValue ?? "Scanned data unavailable",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                formatDate(barcode.scannedAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.share, color: Colors.blue),
                onPressed: () {
                  // Share logic here
                  final shareText = barcode.displayValue ?? "No Data";
                  _shareBarcode(context, shareText);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    BarcodeType.fromRawValue(barcode.typeIndex).name,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal[700],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.backup, color: Colors.orange),
                    onPressed: () {
                      // Backup logic here
                      print('Backup pressed');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final notifier = ref.read(historyViewModelProvider.notifier);
                      await notifier.deleteBarcode(key); // Use the Hive key
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper function for sharing
  void _shareBarcode(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text('Sharing: $text'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
