import 'package:flutter/material.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/peminjam/widgets/common/stock_container.dart';

class RentalSelectionDialog extends StatefulWidget {
  final Set<int> rentedItems;
  final List<Map<String, dynamic>> alatList;
  final void Function(
    DateTime tanggalKembali,
    String keterangan,
    Map<String, int> quantities,
  )
  onSubmit;

  const RentalSelectionDialog({
    super.key,
    required this.rentedItems,
    required this.alatList,
    required this.onSubmit,
  });

  @override
  State<RentalSelectionDialog> createState() => _RentalSelectionDialogState();
}

class _RentalSelectionDialogState extends State<RentalSelectionDialog> {
  final Map<String, int> _quantities = {};
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedTanggalKembali;

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
    for (final index in widget.rentedItems) {
      _quantities['item_$index'] = 1;
    }
  }

  void _incrementQuantity(String key, int maxStock) {
    setState(() {
      final currentQty = _quantities[key] ?? 1;
      if (currentQty < maxStock) {
        _quantities[key] = currentQty + 1;
      }
    });
  }

  void _decrementQuantity(String key) {
    setState(() {
      if ((_quantities[key] ?? 1) > 1) {
        _quantities[key] = (_quantities[key] ?? 1) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rentalItems = [];

    for (final index in widget.rentedItems) {
      if (index < 0 || index >= widget.alatList.length) continue;

      final alat = widget.alatList[index];
      final key = 'item_$index';
      final quantity = _quantities[key] ?? 1;
      final stockTersedia = alat['stok_tersedia'] as int? ?? 0;

      rentalItems.add(
        _buildRentalItemCard(
          name: alat['nama_alat'] ?? '',
          image: alat['alat_url'] ?? '',
          stock: stockTersedia.toString(),
          quantity: quantity,
          onIncrement: () => _incrementQuantity(key, stockTersedia),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                decoration: BoxDecoration(
                  color: Warna.putih,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Barang Sewa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= CONTENT =================
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      "Informasi Peminjaman",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // TANGGAL KEMBALI
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        labelText: 'Tanggal Kembali Rencana',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal kembali wajib diisi';
                        }
                        return null;
                      },
                      onTap: () async {
                        final picked = await showDatePicker(
                          confirmText: "Pilih",
                          cancelText: "Batal",
                          helpText: "Pilih Tanggal Kembali",
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.purple, // header & button
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          _selectedTanggalKembali = picked;
                          _dateController.text =
                              "${picked.day.toString().padLeft(2, '0')}/"
                              "${picked.month.toString().padLeft(2, '0')}/"
                              "${picked.year}";
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // KETERANGAN
                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        labelText: 'Keterangan (Opsional)',
                        prefixIcon: const Icon(Icons.note_alt_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          "Barang Dipilih",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${rentalItems.length} Barang",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ...rentalItems.isEmpty
                        ? const [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('Belum ada barang dipilih'),
                              ),
                            ),
                          ]
                        : rentalItems,
                  ],
                ),
              ),

              // ================= ACTION =================
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (_selectedTanggalKembali == null) return;

                      widget.onSubmit(
                        _selectedTanggalKembali!,
                        _keteranganController.text,
                        _quantities,
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Warna.ungu,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Ajukan Peminjaman',
                      style: TextStyle(color: Warna.putih),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    final int maxStock = int.tryParse(stock) ?? 0;
    final bool isMaxReached = quantity >= maxStock;

    return Card(
      color: Warna.unguTransparan,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Warna.ungu),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Warna.putih,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  StockContainer(stock: stock),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: quantity > 1 ? onDecrement : null,
                  icon: Icon(
                    Icons.remove,
                    color: quantity > 1 ? Warna.hitamBackground : Colors.grey,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    color: Warna.hitamBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: isMaxReached ? null : onIncrement,
                  icon: Icon(
                    Icons.add,
                    color: isMaxReached ? Colors.grey : Warna.hitamBackground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
