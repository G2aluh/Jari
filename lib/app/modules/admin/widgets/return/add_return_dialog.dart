import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 480.0 : 360.0;
    final titleSize = isTablet ? 22.0 : 18.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final textSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(contentPadding),
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

              // Form Fields

              // 1. Pilih Peminjaman (Kode Peminjaman)
              _buildLabel('Kode Peminjaman', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              Container(
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
                  child: DropdownButton<Peminjaman>(
                    isExpanded: true,
                    dropdownColor: Warna.hitamBackground,
                    hint: Text(
                      'Pilih Peminjaman',
                      style: TextStyle(
                        color: Warna.putih.withOpacity(0.5),
                        fontSize: textSize,
                      ),
                    ),
                    value: _selectedPeminjaman,
                    items: widget.controller.peminjamanAktifList.map((p) {
                      return DropdownMenuItem<Peminjaman>(
                        value: p,
                        child: Text(
                          '${p.kodePeminjaman} - ${p.namaPeminjam}',
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: textSize,
                          ),
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
              SizedBox(height: spacing),

              // 2. Tanggal Kembali
              _buildLabel('Tanggal Kembali', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
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
                  padding: EdgeInsets.all(isTablet ? 18 : 16),
                  decoration: BoxDecoration(
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Warna.ungu,
                        size: iconSize,
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Text(
                        '${_tanggalKembali.day}/${_tanggalKembali.month}/${_tanggalKembali.year}',
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: textSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),

              // Info Kalkulasi (Terlambat & Denda)
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : 12),
                decoration: BoxDecoration(
                  color: Warna.ungu.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                  border: Border.all(color: Warna.ungu.withOpacity(0.3)),
                ),
                child: _isCalculating
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 12 : 8),
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
                                  fontSize: textSize,
                                ),
                              ),
                              Text(
                                '$_terlambatHari Hari',
                                style: TextStyle(
                                  color: _terlambatHari > 0
                                      ? Warna.merah.withOpacity(0.7)
                                      : Warna.putih.withOpacity(0.7),
                                  fontSize: textSize,
                                ),
                              ),
                            ],
                          ),
                          if (_totalDenda > 0) ...[
                            SizedBox(height: isTablet ? 12 : 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimasi Denda:',
                                  style: TextStyle(
                                    color: Warna.putih.withOpacity(0.7),
                                    fontSize: textSize,
                                  ),
                                ),
                                Text(
                                  'Rp ${_totalDenda.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
              ),
              SizedBox(height: spacing),

              // 3. Status
              _buildLabel('Status', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              Container(
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
                  child: DropdownButton<StatusPengembalian>(
                    isExpanded: true,
                    dropdownColor: Warna.hitamBackground,
                    value: _selectedStatus,
                    items: StatusPengembalian.values.map((status) {
                      return DropdownMenuItem<StatusPengembalian>(
                        value: status,
                        child: Text(
                          status.displayName,
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: textSize,
                          ),
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
              SizedBox(height: spacing + 8),

              // Action Buttons
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

  Future<void> _submit() async {
    if (_selectedPeminjaman == null) {
      Get.snackbar(
        'Error',
        'Pilih peminjaman terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
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
