import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/peminjaman_controller.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Warna.putih.withOpacity(0.1)),
        ),
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
                  icon: Icon(Icons.close, color: Warna.putih.withOpacity(0.5)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Peminjam Dropdown
            Text(
              'Peminjam',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
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
                      setState(() {
                        _selectedPeminjam = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Pinjam
            Text(
              'Tanggal Pinjam',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Warna.hitamTransparan,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Warna.ungu, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(_tanggalPinjam),
                      style: TextStyle(color: Warna.putih),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal Jatuh Tempo
            Text(
              'Tanggal Jatuh Tempo',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Warna.hitamTransparan,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.event, color: Warna.ungu, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(_tanggalJatuhTempo),
                      style: TextStyle(color: Warna.putih),
                    ),
                  ],
                ),
              ),
            ),
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
                    child: Text('Batal', style: TextStyle(color: Warna.putih)),
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

  Future<void> _submit() async {
    if (_selectedPeminjam == null) {
      Get.snackbar(
        'Error',
        'Pilih peminjam terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await widget.controller.addPeminjaman(
      peminjamId: _selectedPeminjam!.id,
      tanggalPinjam: _tanggalPinjam,
      tanggalJatuhTempo: _tanggalJatuhTempo,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    }
  }
}
