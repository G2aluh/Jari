import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/stock_container.dart';
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
  final TextEditingController _keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeQuantities();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _keteranganController.dispose();
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
            stock: alat.stok,
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
          stock: alat.stok,
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: Warna.putih,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Barang Sewa',
                    style: TextStyle(
                      color: Warna.hitamBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Warna.hitamBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Form Fields Section
                  Text(
                    "Informasi Peminjaman",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Warna.hitamBackground,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Tanggal Kembali Rencana (Date Picker)
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      labelText: 'Tanggal Kembali Rencana',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Warna.ungu,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.ungu),
                      ),
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
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 16),

                  // Keterangan Input
                  TextFormField(
                    controller: _keteranganController,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      alignLabelWithHint: true,
                      labelText: 'Keterangan (Opsional)',
                      hintText: 'Tambahkan catatan jika perlu...',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Icon(
                          Icons.note_alt_outlined,
                          size: 20,
                          color: Warna.ungu,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.ungu),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        "Barang Dipilih",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Warna.hitamBackground,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${rentalItems.length} Barang",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  ...rentalItems.isEmpty
                      ? [
                          Container(
                            padding: EdgeInsets.all(30),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  size: 48,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Belum ada barang dipilih',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : rentalItems,
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Warna.putih,
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Process rental with _keteranganController.text
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shadowColor: Warna.ungu.withOpacity(0.3),
                        elevation: 0,
                        backgroundColor: Warna.ungu,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Ajukan Peminjaman',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
    required String stock,
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Card(
      color: Warna.ungu.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Warna.ungu),
      ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  StockContainer(stock: stock),
                ],
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
