import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:flutter/material.dart';

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
  late StatusPengembalian _status;
  late TextEditingController _terlambatController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.pengembalian.status;
    _terlambatController = TextEditingController(
      text: widget.pengembalian.terlambatHari.toString(),
    );
  }

  @override
  void dispose() {
    _terlambatController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 8),

            // Info
            Text(
              'Peminjaman: ${widget.pengembalian.kodePeminjaman}',
              style: TextStyle(color: Warna.ungu, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Status Dropdown
            Text(
              'Status',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
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
                  value: _status,
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
                      setState(() => _status = value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hari Terlambat
            Text(
              'Hari Terlambat',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _terlambatController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Warna.putih),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                filled: true,
                fillColor: Warna.hitamTransparan,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.ungu),
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

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final success = await widget.controller.updatePengembalian(
      id: widget.pengembalian.id,
      status: _status,
      terlambatHari: int.tryParse(_terlambatController.text) ?? 0,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    }
  }
}
