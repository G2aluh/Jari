import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class EditReturnDialog extends StatefulWidget {
  final Pengembalian pengembalian;
  final PengembalianController controller;

  const EditReturnDialog({
    super.key,
    required this.pengembalian,
    required this.controller,
  });

  @override
  State<EditReturnDialog> createState() => _EditReturnDialogState();
}

class _EditReturnDialogState extends State<EditReturnDialog> {
  late StatusPengembalian _selectedStatus;
  late int _terlambatHari;
  late int _totalDenda;
  late DateTime _tanggalKembali;

  final TextEditingController _terlambatController = TextEditingController();
  final TextEditingController _dendaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Timer? _debounce;

  bool _isLoading = false;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.pengembalian.status;
    _terlambatHari = widget.pengembalian.terlambatHari;
    _totalDenda = widget.pengembalian.denda;
    _tanggalKembali = widget.pengembalian.tanggalKembali;

    _terlambatController.text = _terlambatHari.toString();
    _dendaController.text = _totalDenda.toString();
    _dateController.text = _formatDate(_tanggalKembali);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _terlambatController.dispose();
    _dendaController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Warna.ungu,
              onPrimary: Warna.putih,
              surface: Warna.hitamBackground,
              onSurface: Warna.putih,
            ),
            dialogBackgroundColor: Warna.hitamTransparan,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _tanggalKembali) {
      setState(() {
        _tanggalKembali = picked;
        _dateController.text = _formatDate(picked);
        _isCalculating = true;
      });

      try {
        final result = await widget.controller.calculateReturnDetails(
          peminjamanId: widget.pengembalian.peminjamanId,
          tanggalKembali: picked,
        );

        if (mounted) {
          setState(() {
            _terlambatHari =
                int.tryParse(result['terlambat_hari'].toString()) ?? 0;
            _totalDenda =
                num.tryParse(result['total_denda'].toString())?.toInt() ?? 0;

            _terlambatController.text = _terlambatHari.toString();
            _dendaController.text = _totalDenda.toString();
            _isCalculating = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isCalculating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 480.0 : 360.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final textSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
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
                    'Edit Pengembalian',
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

              // Read-only Info
              _buildReadOnlyField(
                "Kode Peminjaman",
                widget.pengembalian.kodePeminjaman,
                labelSize,
                textSize,
                isTablet,
              ),
              SizedBox(height: isTablet ? 16 : 12),
              _buildReadOnlyField(
                "Peminjam",
                widget.pengembalian.namaPeminjam,
                labelSize,
                textSize,
                isTablet,
              ),
              SizedBox(height: spacing),

              // Form Fields

              // 1. Status
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
              SizedBox(height: spacing),

              // 2. Tanggal Kembali (New)
              _buildLabel('Tanggal Kembali', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    style: TextStyle(color: Warna.putih, fontSize: textSize),
                    decoration: InputDecoration(
                      hintText: 'Pilih Tanggal',
                      filled: true,
                      fillColor: Warna.hitamTransparan,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Warna.ungu,
                        size: isTablet ? 24 : 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),

              // 3. Keterlambatan (Hari) - Read Only & Auto Calc
              _buildLabel('Keterlambatan (Hari) - Otomatis', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              TextField(
                controller: _terlambatController,
                keyboardType: TextInputType.number,
                readOnly: true,
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: textSize,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  filled: true,
                  fillColor: Warna.abuAbu,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                  ),
                ),
              ),
              SizedBox(height: spacing),

              // 4. Denda (Total) - Read Only / Auto Calc
              _buildLabel('Total Denda (Rp) - Otomatis', labelSize),
              SizedBox(height: isTablet ? 12 : 8),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    controller: _dendaController,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.7),
                      fontSize: textSize,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      filled: true,
                      fillColor: Warna.abuAbu,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  if (_isCalculating)
                    Padding(
                      padding: EdgeInsets.only(right: isTablet ? 16 : 12),
                      child: SizedBox(
                        width: isTablet ? 24 : 20,
                        height: isTablet ? 24 : 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Warna.ungu,
                        ),
                      ),
                    ),
                ],
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
                              'Update',
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

  Widget _buildReadOnlyField(
    String label,
    String value,
    double labelSize,
    double textSize,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, labelSize),
        SizedBox(height: isTablet ? 6 : 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 16 : 12,
            horizontal: isTablet ? 20 : 16,
          ),
          decoration: BoxDecoration(
            color: Warna.abuAbu,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Warna.putih.withOpacity(0.1)),
          ),
          child: Text(
            value,
            style: TextStyle(color: Warna.putih, fontSize: textSize),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      final terlambat = int.tryParse(_terlambatController.text) ?? 0;
      final denda = int.tryParse(_dendaController.text) ?? 0;

      final success = await widget.controller.updatePengembalian(
        id: widget.pengembalian.id,
        status: _selectedStatus,
        terlambatHari: terlambat,
        totalDenda: denda,
        tanggalKembali: _tanggalKembali,
      );

      if (success) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
