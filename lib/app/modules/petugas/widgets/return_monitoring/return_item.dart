import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/views/return_monitoring/dialog/detail_pengembalian_dialog.dart';
import 'package:flutter/material.dart';

class ReturnItem extends StatelessWidget {
  final Peminjaman loan;
  final Pengembalian? pengembalian;
  final PetugasDashboardController controller;
  final String status;
  final Color statusColor;

  const ReturnItem({
    super.key,
    required this.loan,
    this.pengembalian,
    required this.controller,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DetailPengembalianDialog(
              loan: loan,
              pengembalian: pengembalian,
              controller: controller,
            ),
          );
        },
        contentPadding: EdgeInsets.all(16),
        title: Text(
          loan.kodePeminjaman ?? loan.id.substring(0, 8),
          style: TextStyle(color: Warna.putih),
        ),
        subtitle: Text(
          'Harus kembali: ${loan.tanggalJatuhTempoFormatted}',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(status, style: TextStyle(color: statusColor)),
        ),
      ),
    );
  }
}
