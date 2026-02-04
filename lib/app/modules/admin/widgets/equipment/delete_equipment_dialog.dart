import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/equipment_controller.dart';
import 'package:jari/app/modules/admin/models/alat_model.dart';
import 'package:flutter/material.dart';

class DeleteEquipmentDialog extends StatefulWidget {
  final Alat alat;
  final EquipmentController controller;

  const DeleteEquipmentDialog({
    super.key,
    required this.alat,
    required this.controller,
  });

  @override
  State<DeleteEquipmentDialog> createState() => _DeleteEquipmentDialogState();
}

class _DeleteEquipmentDialogState extends State<DeleteEquipmentDialog> {
  bool isLoading = false;

  Future<void> _handleToggle() async {
    setState(() => isLoading = true);

    bool success;
    if (widget.alat.aktif) {
      success = await widget.controller.deleteEquipment(widget.alat.id);
    } else {
      success = await widget.controller.activateEquipment(widget.alat.id);
    }

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.alat.aktif;
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 450.0 : 320.0;
    final titleSize = isTablet ? 20.0 : 16.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final smallSize = isTablet ? 14.0 : 12.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final imageSize = isTablet ? 50.0 : 40.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isActive ? 'Nonaktifkan Alat' : 'Aktifkan Alat',
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Text(
              isActive
                  ? 'Apakah Anda yakin ingin menonaktifkan alat ini?'
                  : 'Apakah Anda yakin ingin mengaktifkan kembali alat ini?',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: bodySize,
              ),
            ),
            SizedBox(height: spacing),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Warna.hitamTransparan,
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                border: Border.all(
                  color: isActive
                      ? Colors.red.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: Warna.abuAbu,
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                      child:
                          widget.alat.alatUrl != null &&
                              widget.alat.alatUrl!.isNotEmpty
                          ? Image.network(
                              widget.alat.alatUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.build,
                                color: Warna.putih.withOpacity(0.5),
                                size: isTablet ? 24 : 20,
                              ),
                            )
                          : Icon(
                              Icons.build,
                              color: Warna.putih.withOpacity(0.5),
                              size: isTablet ? 24 : 20,
                            ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alat.namaAlat,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: bodySize,
                          ),
                        ),
                        Text(
                          widget.alat.kodeAlat,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: smallSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              isActive
                  ? '*Alat tidak akan muncul dalam daftar peminjaman'
                  : '*Alat akan dapat dipinjam kembali',
              style: TextStyle(
                color: isActive ? Colors.orange : Colors.green,
                fontSize: smallSize,
              ),
            ),
            SizedBox(height: spacing + 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 16,
                      vertical: isTablet ? 12 : 8,
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.7),
                      fontSize: buttonFontSize,
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.red : Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleToggle,
                  child: isLoading
                      ? SizedBox(
                          width: isTablet ? 24 : 20,
                          height: isTablet ? 24 : 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Warna.putih,
                          ),
                        )
                      : Text(
                          isActive ? 'Nonaktifkan' : 'Aktifkan',
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
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
}
