import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/user_management_controller.dart';
import 'package:jari/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';

class ActivateUserDialog extends StatefulWidget {
  final Pengguna user;
  final UserManagementController controller;

  const ActivateUserDialog({
    super.key,
    required this.user,
    required this.controller,
  });

  @override
  State<ActivateUserDialog> createState() => _ActivateUserDialogState();
}

class _ActivateUserDialogState extends State<ActivateUserDialog> {
  bool isLoading = false;

  Future<void> _handleActivate() async {
    setState(() => isLoading = true);

    final success = await widget.controller.activateUser(widget.user.id);

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final avatarRadius = isTablet ? 24.0 : 20.0;

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
                  'Aktifkan Pengguna',
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
              'Apakah Anda yakin ingin mengaktifkan kembali pengguna ini?',
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
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Warna.ungu.withOpacity(0.2),
                    child: Text(
                      widget.user.nama.isNotEmpty
                          ? widget.user.nama[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Warna.ungu,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 18 : 14,
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nama,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: bodySize,
                          ),
                        ),
                        SizedBox(height: isTablet ? 4 : 2),
                        Text(
                          widget.user.email,
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
              '*Pengguna akan dapat login kembali.',
              style: TextStyle(color: Colors.green, fontSize: smallSize),
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
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleActivate,
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
                          'Aktifkan',
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
