import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/peminjaman_controller.dart';
import 'package:jari/app/modules/admin/models/alat_model.dart';
import 'package:jari/app/modules/admin/models/detail_peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPeminjamanDialog extends StatefulWidget {
  final PeminjamanController controller;

  const AddPeminjamanDialog({super.key, required this.controller});

  @override
  State<AddPeminjamanDialog> createState() => _AddPeminjamanDialogState();
}

class _AddPeminjamanDialogState extends State<AddPeminjamanDialog> {
  Pengguna? _selectedPeminjam;
  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalJatuhTempo = DateTime.now().add(const Duration(days: 7));

  // Alat Selection State
  Alat? _tempSelectedAlat;
  final TextEditingController _jumlahController = TextEditingController(
    text: '1',
  );
  final List<AlatSelection> _selectedAlatList = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500, // Lebarkan sedikit agar muat list alat
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Warna.putih.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tambah Peminjaman',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Peminjam Dropdown
              _buildLabel('Peminjam'),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Pengguna>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Pilih Peminjam',
                        style: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      ),
                      value: _selectedPeminjam,
                      items: widget.controller.peminjamList.map((peminjam) {
                        return DropdownMenuItem<Pengguna>(
                          value: peminjam,
                          child: Text(
                            peminjam.nama,
                            style: TextStyle(color: Warna.putih),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedPeminjam = value);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Sections
              // Tanggal Sections
              _buildLabel('Tanggal Pinjam'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: _buildDateBox(_tanggalPinjam, Icons.calendar_today),
              ),
              const SizedBox(height: 16),

              _buildLabel('Jatuh Tempo'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: _buildDateBox(_tanggalJatuhTempo, Icons.event),
              ),
              const SizedBox(height: 24),
              Divider(color: Warna.putih.withOpacity(0.1)),
              const SizedBox(height: 16),

              // Alat Selection Section
              _buildLabel('Pilih Alat'),
              const SizedBox(height: 8),

              // Row 1: Dropdown Full Width
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Alat>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Pilih Alat',
                        style: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      ),
                      value: _tempSelectedAlat,
                      items: widget.controller.alatList.map((alat) {
                        return DropdownMenuItem<Alat>(
                          value: alat,
                          child: Text(
                            '${alat.namaAlat} (Stok: ${alat.stokTersedia})',
                            style: TextStyle(color: Warna.putih),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _tempSelectedAlat = value);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Row 2: Quantity and Add Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        hintText: 'Jumlah Item',
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: Warna.putih.withOpacity(0.5),
                          size: 18,
                        ),
                        hintStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: Warna.hitamTransparan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Warna.ungu),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Warna.ungu,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _addAlatToList,
                      icon: Icon(Icons.add, color: Warna.putih),
                      tooltip: 'Tambah Alat',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selected Alat List
              if (_selectedAlatList.isNotEmpty) ...[
                _buildLabel('Daftar Alat Dipinjam'),
                const SizedBox(height: 8),
                Container(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _selectedAlatList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final selection = _selectedAlatList[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Warna.hitamTransparan,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Warna.putih.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selection.alat.namaAlat,
                                    style: TextStyle(
                                      color: Warna.putih,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Kode: ${selection.alat.kodeAlat}',
                                    style: TextStyle(
                                      color: Warna.putih.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${selection.jumlah}x',
                              style: TextStyle(
                                color: Warna.ungu,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedAlatList.removeAt(index);
                                });
                              },
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red.withOpacity(0.7),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Warna.putih),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Warna.putih,
                              ),
                            )
                          : Text(
                              'Simpan',
                              style: TextStyle(
                                color: Warna.putih,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Warna.putih.withOpacity(0.7), fontSize: 14),
    );
  }

  Widget _buildDateBox(DateTime date, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Warna.ungu, size: 20),
          const SizedBox(width: 12),
          Text(_formatDate(date), style: TextStyle(color: Warna.putih)),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPinjam ? _tanggalPinjam : _tanggalJatuhTempo,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Warna.ungu,
              onPrimary: Warna.putih,
              surface: Warna.hitamBackground,
              onSurface: Warna.putih,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
        } else {
          _tanggalJatuhTempo = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _addAlatToList() {
    if (_tempSelectedAlat == null) return;

    final jumlahStr = _jumlahController.text;
    final jumlah = int.tryParse(jumlahStr) ?? 0;

    if (jumlah <= 0) {
      Get.snackbar(
        'Error',
        'Jumlah harus lebih dari 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    if (jumlah > _tempSelectedAlat!.stokTersedia) {
      Get.snackbar(
        'Stok Tidak Cukup',
        'Stok tidak mencukupi (Tersedia: ${_tempSelectedAlat!.stokTersedia})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    // Cek apakah alat sudah ada di list
    final existingIndex = _selectedAlatList.indexWhere(
      (item) => item.alat.id == _tempSelectedAlat!.id,
    );

    setState(() {
      if (existingIndex != -1) {
        // Update jumlah jika sudah ada
        final currentJumlah = _selectedAlatList[existingIndex].jumlah;
        if (currentJumlah + jumlah > _tempSelectedAlat!.stokTersedia) {
          Get.snackbar(
            'Error',
            'Total jumlah melebihi stok tersedia',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          );
          return;
        }
        _selectedAlatList[existingIndex].jumlah += jumlah;
      } else {
        // Tambah baru
        _selectedAlatList.add(
          AlatSelection(alat: _tempSelectedAlat!, jumlah: jumlah),
        );
      }

      // Reset selection
      _tempSelectedAlat = null;
      _jumlahController.text = '1';
    });
  }

  Future<void> _submit() async {
    if (_selectedPeminjam == null) {
      Get.snackbar(
        'Error',
        'Pilih peminjam terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    if (_selectedAlatList.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih minimal satu alat',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await widget.controller.addPeminjaman(
      peminjamId: _selectedPeminjam!.id,
      tanggalPinjam: _tanggalPinjam,
      tanggalJatuhTempo: _tanggalJatuhTempo,
      selectedAlat: _selectedAlatList,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    }
  }
}
