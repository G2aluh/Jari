import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 560.0 : 500.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final textSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(borderRadius),
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
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.5),
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing + 8),

              // Peminjam Dropdown
              _buildLabel('Peminjam', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Pengguna>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Pilih Peminjam',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: textSize,
                        ),
                      ),
                      value: _selectedPeminjam,
                      items: widget.controller.peminjamList.map((peminjam) {
                        return DropdownMenuItem<Pengguna>(
                          value: peminjam,
                          child: Text(
                            peminjam.nama,
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: textSize,
                            ),
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
              SizedBox(height: spacing),

              // Tanggal Sections
              _buildLabel('Tanggal Pinjam', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: _buildDateBox(
                  _tanggalPinjam,
                  Icons.calendar_today,
                  isTablet,
                  iconSize,
                  textSize,
                ),
              ),
              SizedBox(height: spacing),

              _buildLabel('Jatuh Tempo', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: _buildDateBox(
                  _tanggalJatuhTempo,
                  Icons.event,
                  isTablet,
                  iconSize,
                  textSize,
                ),
              ),
              SizedBox(height: spacing + 8),
              Divider(color: Warna.putih.withOpacity(0.1)),
              SizedBox(height: spacing),

              // Alat Selection Section
              _buildLabel('Pilih Alat', labelSize),
              SizedBox(height: isTablet ? 12 : 8),

              // Row 1: Dropdown Full Width
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 12,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Alat>(
                      isExpanded: true,
                      dropdownColor: Warna.hitamBackground,
                      hint: Text(
                        'Pilih Alat',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: textSize,
                        ),
                      ),
                      value: _tempSelectedAlat,
                      items: widget.controller.alatList.map((alat) {
                        return DropdownMenuItem<Alat>(
                          value: alat,
                          child: Text(
                            '${alat.namaAlat} (Stok: ${alat.stokTersedia})',
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: textSize,
                            ),
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
              SizedBox(height: isTablet ? 16 : 12),

              // Row 2: Quantity and Add Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih, fontSize: textSize),
                      decoration: InputDecoration(
                        hintText: 'Jumlah Item',
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: Warna.putih.withOpacity(0.5),
                          size: isTablet ? 22 : 18,
                        ),
                        hintStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: textSize,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 12,
                          vertical: isTablet ? 18 : 14,
                        ),
                        filled: true,
                        fillColor: Warna.hitamTransparan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          borderSide: BorderSide(color: Warna.ungu),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Warna.ungu,
                      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    ),
                    child: IconButton(
                      onPressed: _addAlatToList,
                      icon: Icon(Icons.add, color: Warna.putih, size: iconSize),
                      tooltip: 'Tambah Alat',
                      padding: EdgeInsets.all(isTablet ? 14 : 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),

              // Selected Alat List
              if (_selectedAlatList.isNotEmpty) ...[
                _buildLabel('Daftar Alat Dipinjam', labelSize),
                SizedBox(height: isTablet ? 12 : 8),
                Container(
                  constraints: BoxConstraints(maxHeight: isTablet ? 180 : 150),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _selectedAlatList.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: isTablet ? 12 : 8),
                    itemBuilder: (context, index) {
                      final selection = _selectedAlatList[index];
                      return Container(
                        padding: EdgeInsets.all(isTablet ? 16 : 12),
                        decoration: BoxDecoration(
                          color: Warna.hitamTransparan,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
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
                                      fontSize: textSize,
                                    ),
                                  ),
                                  Text(
                                    'Kode: ${selection.alat.kodeAlat}',
                                    style: TextStyle(
                                      color: Warna.putih.withOpacity(0.6),
                                      fontSize: isTablet ? 14 : 12,
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
                                fontSize: textSize,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedAlatList.removeAt(index);
                                });
                              },
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  left: isTablet ? 12 : 8,
                                ),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red.withOpacity(0.7),
                                  size: iconSize,
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

              SizedBox(height: spacing + 8),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: isTablet ? 24 : 20,
                              height: isTablet ? 24 : 20,
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
                                fontSize: buttonFontSize,
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

  Widget _buildLabel(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(color: Warna.putih.withOpacity(0.7), fontSize: fontSize),
    );
  }

  Widget _buildDateBox(
    DateTime date,
    IconData icon,
    bool isTablet,
    double iconSize,
    double textSize,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 18 : 16),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Warna.ungu, size: iconSize),
          SizedBox(width: isTablet ? 16 : 12),
          Text(
            _formatDate(date),
            style: TextStyle(color: Warna.putih, fontSize: textSize),
          ),
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
