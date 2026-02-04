import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogMaxWidth = isTablet ? 450.0 : 320.0;
    final padding = isTablet ? 32.0 : 20.0;
    final titleSize = isTablet ? 24.0 : 18.0;
    final bodySize = isTablet ? 18.0 : 14.0;
    final buttonTextSize = isTablet ? 18.0 : 14.0;
    final buttonPadding = isTablet ? 18.0 : 12.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Warna.hitamBackground,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Warna.abuAbu),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Konfirmasi Logout",
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Warna.putih,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Warna.putih, size: iconSize),
                    padding: EdgeInsets.all(isTablet ? 8 : 4),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              Text(
                "Apakah Anda yakin ingin keluar dari akun ini?",
                style: TextStyle(
                  fontSize: bodySize,
                  color: Warna.putih,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing + 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog first
                        onConfirm(); // Trigger actual logout
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                        ),
                      ),
                      child: Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonTextSize,
                          fontWeight: FontWeight.w600,
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
}
