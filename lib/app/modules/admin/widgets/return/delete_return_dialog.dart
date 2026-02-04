import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 420.0 : 360.0;
    final titleSize = isTablet ? 22.0 : 20.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 20.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconSize = isTablet ? 50.0 : 40.0;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: iconSize,
              ),
            ),
            SizedBox(height: spacing),

            // Title
            Text(
              'Hapus Pengembalian',
              style: TextStyle(
                color: Warna.putih,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),

            // Message
            Text(
              'Apakah Anda yakin ingin menghapus data pengembalian untuk peminjaman "${widget.pengembalian.kodePeminjaman}"?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: bodySize,
              ),
            ),
            SizedBox(height: spacing + 4),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                    onPressed: _isLoading ? null : _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
                            'Hapus',
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
