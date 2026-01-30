import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:flutter/material.dart';

class DeleteReturnDialog extends StatefulWidget {
  final Pengembalian pengembalian;
  final PengembalianController controller;

  const DeleteReturnDialog({
    super.key,
    required this.pengembalian,
    required this.controller,
  });

  @override
  State<DeleteReturnDialog> createState() => _DeleteReturnDialogState();
}

class _DeleteReturnDialogState extends State<DeleteReturnDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Warna.hitamBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Warna.putih.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Hapus Pengembalian',
              style: TextStyle(
                color: Warna.putih,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              'Apakah Anda yakin ingin menghapus data pengembalian untuk peminjaman "${widget.pengembalian.kodePeminjaman}"?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: 14,
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
                    onPressed: _isLoading ? null : _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
                            'Hapus',
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

  Future<void> _delete() async {
    setState(() => _isLoading = true);

    final success = await widget.controller.deletePengembalian(
      widget.pengembalian.id,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    }
  }
}
