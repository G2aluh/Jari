import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/peminjaman_controller.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';

class EditLoanDialog extends StatefulWidget {
  final Peminjaman peminjaman;
  final PeminjamanController controller;

  const EditLoanDialog({
    super.key,
    required this.peminjaman,
    required this.controller,
  });

  @override
  State<EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<EditLoanDialog> {
  late StatusPeminjaman _status;
  late DateTime _tanggalJatuhTempo;
  late TextEditingController _catatanController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.peminjaman.status;
    _tanggalJatuhTempo = widget.peminjaman.tanggalJatuhTempo ?? DateTime.now();
    _catatanController = TextEditingController(
      text: widget.peminjaman.catatanPenolakan ?? '',
    );
  }

  @override
  void dispose() {
    _catatanController.dispose();
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
                  'Edit Peminjaman',
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Warna.putih),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Kode Peminjaman (read-only)
            Text(
              'Kode: ${widget.peminjaman.kodePeminjaman ?? "-"}',
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
                child: DropdownButton<StatusPeminjaman>(
                  isExpanded: true,
                  dropdownColor: Warna.hitamBackground,
                  value: _status,
                  items: StatusPeminjaman.values.map((status) {
                    return DropdownMenuItem<StatusPeminjaman>(
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
              onTap: _selectDate,
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
            const SizedBox(height: 16),

            // Catatan (visible when ditolak)
            if (_status == StatusPeminjaman.ditolak) ...[
              Text(
                'Catatan Penolakan',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _catatanController,
                maxLines: 3,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  hintText: 'Masukkan alasan penolakan...',
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
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),

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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalJatuhTempo,
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
      setState(() => _tanggalJatuhTempo = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    final success = await widget.controller.updatePeminjaman(
      id: widget.peminjaman.id,
      status: _status,
      tanggalJatuhTempo: _tanggalJatuhTempo,
      catatanPenolakan: _status == StatusPeminjaman.ditolak
          ? _catatanController.text
          : null,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    }
  }
}
