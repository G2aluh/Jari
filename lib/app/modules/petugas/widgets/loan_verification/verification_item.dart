import 'package:jari/app/core/theme/app_colors.dart';
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
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          loan.kodePeminjaman ?? loan.id.substring(0, 8),
          style: TextStyle(color: Warna.putih),
        ),
        subtitle: Text(
          'Tanggal: ${loan.tanggalPinjamFormatted}',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
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
              icon: Icon(Icons.check, color: Colors.green),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    RejectionDialog(loan: loan, controller: controller),
              ),
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
