import 'package:jari/app/core/theme/app_colors.dart';
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

      // Auto-calculate details based on new date
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
                  'Edit Pengembalian',
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

            // Read-only Info
            _buildReadOnlyField(
              "Kode Peminjaman",
              widget.pengembalian.kodePeminjaman,
            ),
            const SizedBox(height: 12),
            _buildReadOnlyField("Peminjam", widget.pengembalian.namaPeminjam),
            const SizedBox(height: 16),

            // Form Fields

            // 1. Status
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
            const SizedBox(height: 16),

            // 2. Tanggal Kembali (New)
            _buildLabel('Tanggal Kembali'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  style: TextStyle(color: Warna.putih),
                  decoration: InputDecoration(
                    hintText: 'Pilih Tanggal',
                    filled: true,
                    fillColor: Warna.hitamTransparan,
                    suffixIcon: Icon(Icons.calendar_today, color: Warna.ungu),
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Keterlambatan (Hari) - Read Only & Auto Calc
            _buildLabel('Keterlambatan (Hari) - Otomatis'),
            const SizedBox(height: 8),
            TextField(
              controller: _terlambatController,
              keyboardType: TextInputType.number,
              readOnly: true, // Make it read only
              style: TextStyle(color: Warna.putih.withOpacity(0.7)),
              decoration: InputDecoration(
                hintText: '0',
                filled: true,
                fillColor: Warna.abuAbu, // Visual indication
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.1)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Denda (Total) - Read Only / Auto Calc
            _buildLabel('Total Denda (Rp) - Otomatis'),
            const SizedBox(height: 8),
            Container(
              // Wrap TextField to show loading
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    controller: _dendaController,
                    keyboardType: TextInputType.number,
                    readOnly: true, // Make it read only as it's auto calc
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    decoration: InputDecoration(
                      hintText: '0',
                      filled: true,
                      fillColor: Warna.abuAbu,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Warna.putih.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  if (_isCalculating)
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Warna.ungu,
                        ),
                      ),
                    ),
                ],
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
                            'Update',
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

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Warna.abuAbu,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Warna.putih.withOpacity(0.1)),
          ),
          child: Text(
            value,
            style: TextStyle(color: Warna.putih, fontSize: 14),
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
