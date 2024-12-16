import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_scanner_workerbase/config/keys.dart';
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

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredHistory = []; // Filtered list

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      final history = ref.read(historyViewModelProvider);
      final query = _searchController.text.toLowerCase();

      _filteredHistory = history
          .where((entry) =>
      entry.value.displayValue?.toLowerCase().contains(query) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyViewModelProvider);
    _filteredHistory =
    _searchController.text.isEmpty ? history : _filteredHistory;

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(appBarTitleHistory, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                setState(() {
                  _selectedItems.clear();
                  _isSelectionMode = false;
                });
              },
            ),
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchController.clear(); // Clears the text
                      FocusScope.of(context).unfocus(); // Removes focus
                    });
                  },
                )
                    : null,
                // Shows close button only when there is input
                hintText: searchHintText,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) =>
                  _onSearchChanged(), // Update search results dynamically
            ),
          ),

          Expanded(
            child: _filteredHistory.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    noItemsFoundImagePath,
                    height: 200.0,
                    width: 200.0,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    noScannedQRCodesMessage,
                    style: TextStyle(
                        fontSize: 18, color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                final entry = _filteredHistory[index];
                final key = entry.key;
                final barcode = entry.value;
                final isSelected =
                _selectedItems.contains(key.toString());

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(completeContentTitle),
                              content: Text(barcode.displayValue ?? scannedDataUnavailable),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(buttonClose),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        barcode.displayValue ?? scannedDataUnavailable,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
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
                              color: Colors.teal),
                          onPressed: () {
                            // todo: Implement backup feature
                            featureNotImplementedToast();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share,
                              color: Colors.teal),
                          onPressed: () {
                            final shareText =
                                barcode.displayValue ?? scannedDataUnavailable;
                            final shareDate =
                            formatDate(barcode.scannedAt);
                            shareContent(
                                '$scannedValuePrefix: $shareText\n$scannedAtPrefix: $shareDate');
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}