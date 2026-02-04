import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/views/loan_verification/dialog/loan_verification_dialog.dart';
import 'package:jari/app/modules/petugas/widgets/loan_verification/rejection_dialog.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';

class VerificationItem extends StatelessWidget {
  final Peminjaman loan;
  final PetugasDashboardController controller;

  const VerificationItem({
    super.key,
    required this.loan,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final padding = isTablet ? 20.0 : 8.0;
    final titleSize = isTablet ? 20.0 : 14.0;
    final subtitleSize = isTablet ? 16.0 : 12.0;
    final iconSize = isTablet ? 32.0 : 24.0;
    final borderRadius = isTablet ? 16.0 : 12.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 8,
          vertical: isTablet ? 8 : 0,
        ),
        title: Text(
          loan.kodePeminjaman ?? loan.id.substring(0, 8),
          style: TextStyle(
            color: Warna.putih,
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: isTablet ? 8 : 4),
          child: Text(
            'Tanggal: ${loan.tanggalPinjamFormatted}',
            style: TextStyle(
              color: Warna.putih.withOpacity(0.7),
              fontSize: subtitleSize,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => KonfirmasiPeminjamanDialog(
                  loan: loan,
                  controller: controller,
                ),
              ),
              icon: Icon(Icons.check, color: Colors.green, size: iconSize),
              padding: EdgeInsets.all(isTablet ? 12 : 8),
            ),
            SizedBox(width: isTablet ? 8 : 0),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    RejectionDialog(loan: loan, controller: controller),
              ),
              icon: Icon(Icons.close, color: Colors.red, size: iconSize),
              padding: EdgeInsets.all(isTablet ? 12 : 8),
            ),
          ],
        ),
      ),
    );
  }
}
