import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddReturnDialog extends StatefulWidget {
  final PengembalianController controller;

  const AddReturnDialog({super.key, required this.controller});

  @override
  State<AddReturnDialog> createState() => _AddReturnDialogState();
}

class _AddReturnDialogState extends State<AddReturnDialog> {
  Peminjaman? _selectedPeminjaman;
  StatusPengembalian _selectedStatus = StatusPengembalian.menunggu;
  DateTime _tanggalKembali = DateTime.now();

  int _terlambatHari = 0;
  num _totalDenda = 0;
  bool _isCalculating = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // No initial calculation needed as loan is not selected
  }

  Future<void> _calculateDetails() async {
    if (_selectedPeminjaman == null) return;

    setState(() => _isCalculating = true);

    final result = await widget.controller.calculateReturnDetails(
      peminjamanId: _selectedPeminjaman!.id,
      tanggalKembali: _tanggalKembali,
    );

    if (mounted) {
      setState(() {
        _terlambatHari = int.tryParse(result['terlambat_hari'].toString()) ?? 0;
        _totalDenda = num.tryParse(result['total_denda'].toString()) ?? 0;
        _isCalculating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tambah Pengembalian',
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 18,
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

            // Form Fields

            // 1. Pilih Peminjaman (Kode Peminjaman)
            _buildLabel('Kode Peminjaman'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Warna.hitamTransparan,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Warna.putih.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Peminjaman>(
                  isExpanded: true,
                  dropdownColor: Warna.hitamBackground,
                  hint: Text(
                    'Pilih Peminjaman',
                    style: TextStyle(color: Warna.putih.withOpacity(0.5)),
                  ),
                  value: _selectedPeminjaman,
                  items: widget.controller.peminjamanAktifList.map((p) {
                    return DropdownMenuItem<Peminjaman>(
                      value: p,
                      child: Text(
                        '${p.kodePeminjaman} - ${p.namaPeminjam}',
                        style: TextStyle(color: Warna.putih),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeminjaman = value;
                    });
                    _calculateDetails();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Tanggal Kembali
            _buildLabel('Tanggal Kembali'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _tanggalKembali,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Warna.ungu,
                          onPrimary: Colors.white,
                          surface: Warna.hitamBackground,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: Warna.hitamBackground,
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => _tanggalKembali = picked);
                  _calculateDetails();
                }
              },
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
                      '${_tanggalKembali.day}/${_tanggalKembali.month}/${_tanggalKembali.year}',
                      style: TextStyle(color: Warna.putih),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info Kalkulasi (Terlambat & Denda)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.ungu.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Warna.ungu.withOpacity(0.3)),
              ),
              child: _isCalculating
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Keterlambatan:',
                              style: TextStyle(
                                color: Warna.putih.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              '$_terlambatHari Hari',
                              style: TextStyle(
                                color: _terlambatHari > 0
                                    ? Warna.merah.withOpacity(0.7)
                                    : Warna.putih.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        if (_totalDenda > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimasi Denda:',
                                style: TextStyle(
                                  color: Warna.putih.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                'Rp ${_totalDenda.toStringAsFixed(0)}', // Basic formatting
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // 3. Status
            _buildLabel('Status'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Warna.hitamTransparan,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Warna.putih.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StatusPengembalian>(
                  isExpanded: true,
                  dropdownColor: Warna.hitamBackground,
                  value: _selectedStatus,
                  items: StatusPengembalian.values.map((status) {
                    return DropdownMenuItem<StatusPengembalian>(
                      value: status,
                      child: Text(
                        status.displayName,
                        style: TextStyle(color: Warna.putih),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStatus = value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Warna.putih.withOpacity(0.7), fontSize: 14),
    );
  }

  Future<void> _submit() async {
    if (_selectedPeminjaman == null) {
      Get.snackbar(
        'Error',
        'Pilih peminjaman terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use the calculated _terlambatHari from RPC
      // Note: If you changed the date but RPC failed/hasn't finished, _terlambatHari might be stale.
      // But _isCalculating handles the loading state.

      final success = await widget.controller.addPengembalian(
        peminjamanId: _selectedPeminjaman!.id,
        tanggalKembali: _tanggalKembali,
        status: _selectedStatus,
        terlambatHari: _terlambatHari,
        totalDenda: _totalDenda.toInt(),
      );

      if (success) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
