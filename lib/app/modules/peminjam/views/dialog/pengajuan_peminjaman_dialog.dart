import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

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
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeQuantities();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
                color: Warna.putih,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Barang Sewa',
                        style: TextStyle(
                          color: Warna.hitamBackground,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Warna.hitamBackground,
                        ),
                      ),
                    ],
                  ),
                  //Form Tanggal Kembali Rencana (Date Picker)
                  //Form Tanggal Kembali Rencana (Date Picker)
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Warna.putih,
                      labelText: 'Tanggal Kembali Rencana',
                      suffixIcon: Icon(Icons.calendar_today, color: Warna.abuAbu),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Warna.ungu,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Warna.ungu,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        // Format date to dd/MM/yyyy
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
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
                color: Warna.putih,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Here you can process the rental items with their quantities
                        // For now, just close the dialog
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: Warna.ungu,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconlyBold.bag, color: Warna.putih),
                          SizedBox(width: 8),
                          const Text(
                            'Sewa Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
      color: Warna.ungu.withOpacity(0.2),
      elevation: 0,
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
                color: Warna.putih,
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
                color: Warna.putih,
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
