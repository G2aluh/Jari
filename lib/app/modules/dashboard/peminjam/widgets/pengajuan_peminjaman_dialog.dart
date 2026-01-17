import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:flutter/material.dart';

class RentalSelectionDialog extends StatefulWidget {
  final Set<int> rentedItems;
  final Set<String> rentedNewItem;
  final List<Alat> alatList;
  final List<AlatProdukBaru> alatProdukBaruList;

  const RentalSelectionDialog({
    super.key,
    required this.rentedItems,
    required this.rentedNewItem,
    required this.alatList,
    required this.alatProdukBaruList,
  });

  @override
  State<RentalSelectionDialog> createState() => _RentalSelectionDialogState();
}

class _RentalSelectionDialogState extends State<RentalSelectionDialog> {
  Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _initializeQuantities();
  }

  void _initializeQuantities() {
    setState(() {
      _quantities = {};
      // Initialize quantities for selected regular items
      for (int index in widget.rentedItems) {
        if (index >= 0 && index < widget.alatList.length) {
          _quantities['regular_$index'] = 1;
        }
      }
      // Initialize quantities for selected new items
      for (String itemName in widget.rentedNewItem) {
        _quantities['new_$itemName'] = 1;
      }
    });
  }

  void _incrementQuantity(String key) {
    setState(() {
      _quantities[key] = (_quantities[key] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String key) {
    setState(() {
      if ((_quantities[key] ?? 0) > 1) {
        _quantities[key] = (_quantities[key] ?? 0) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rentalItems = [];

    // Add regular rental items
    for (int index in widget.rentedItems) {
      if (index >= 0 && index < widget.alatList.length) {
        final alat = widget.alatList[index];
        String key = 'regular_$index';
        int quantity = _quantities[key] ?? 1;

        rentalItems.add(
          _buildRentalItemCard(
            name: alat.nama,
            image: alat.gambar,
            quantity: quantity,
            onIncrement: () => _incrementQuantity(key),
            onDecrement: () => _decrementQuantity(key),
          ),
        );
      }
    }

    // Add new rental items
    for (String itemName in widget.rentedNewItem) {
      final alat = widget.alatProdukBaruList.firstWhere(
        (element) => element.nama == itemName,
        orElse: () => AlatProdukBaru(nama: itemName, stok: '0', gambar: ''),
      );
      String key = 'new_$itemName';
      int quantity = _quantities[key] ?? 1;

      rentalItems.add(
        _buildRentalItemCard(
          name: alat.nama,
          image: alat.gambar,
          quantity: quantity,
          onIncrement: () => _incrementQuantity(key),
          onDecrement: () => _decrementQuantity(key),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Warna.ungu,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Barang Sewa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: rentalItems.isEmpty
                      ? [
                          Center(
                            child: Text(
                              'Tidak ada barang yang dipilih',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]
                      : rentalItems,
                ),
              ),
            ),
            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Here you can process the rental items with their quantities
                        // For now, just close the dialog
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Sewa Sekarang'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalItemCard({
    required String name,
    required String image,
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(image, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            // Item name
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Quantity controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onDecrement,
                    icon: const Icon(
                      Icons.remove,
                      size: 18,
                      color: Colors.black,
                    ),
                    splashRadius: 16,
                    padding: const EdgeInsets.all(4),
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: onIncrement,
                    icon: const Icon(Icons.add, size: 18, color: Colors.black),
                    splashRadius: 16,
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
