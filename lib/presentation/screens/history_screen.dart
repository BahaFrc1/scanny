import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/scanner_utils.dart';
import '../../utils/converter.dart';
import '../providers/providers.dart';
import '../widgets/toast.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Set<String> _selectedItems = {};
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Scan History', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _selectedItems.clear();
                  _isSelectionMode = false;
                });
              },
            ),
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final notifier = ref.read(historyViewModelProvider.notifier);
                for (final key in _selectedItems) {
                  await notifier.deleteBarcode(int.parse(key));
                }
                setState(() {
                  _selectedItems.clear();
                  _isSelectionMode = false;
                });
              },
            ),
        ],
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
                final isSelected = _selectedItems.contains(key.toString());

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
                    subtitle: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          formatDate(barcode.scannedAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    leading: Icon(
                      getBarcodeIcon(barcode.typeIndex),
                      color: Colors.teal[700],
                    ),
                    trailing: _isSelectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedItems.add(key.toString());
                                } else {
                                  _selectedItems.remove(key.toString());
                                }
                              });
                            },
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.backup,
                                    color: Colors.blue),
                                onPressed: () {
                                  // todo: Implement backup feature
                                  featureNotImplementedToast();
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () {
                                  final shareText =
                                      barcode.displayValue ?? "No Data";
                                  final shareDate =
                                      formatDate(barcode.scannedAt);
                                  shareContent(
                                      'Scanned Value: $shareText\nScanned At: $shareDate');
                                },
                              ),
                            ],
                          ),
                    onLongPress: () {
                      setState(() {
                        _isSelectionMode = true;
                        if (isSelected) {
                          _selectedItems.remove(key.toString());
                        } else {
                          _selectedItems.add(key.toString());
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
