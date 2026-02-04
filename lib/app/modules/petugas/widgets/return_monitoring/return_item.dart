import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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
    final isTablet = Responsive.isTablet(context);
    final contentPadding = isTablet ? 24.0 : 16.0;
    final titleSize = isTablet ? 20.0 : 14.0;
    final subtitleSize = isTablet ? 16.0 : 12.0;
    final statusPaddingH = isTablet ? 18.0 : 12.0;
    final statusPaddingV = isTablet ? 10.0 : 6.0;
    final statusFontSize = isTablet ? 16.0 : 12.0;
    final borderRadius = isTablet ? 16.0 : 12.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(borderRadius),
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
        contentPadding: EdgeInsets.all(contentPadding),
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
            'Harus kembali: ${loan.tanggalJatuhTempoFormatted}',
            style: TextStyle(
              color: Warna.putih.withOpacity(0.7),
              fontSize: subtitleSize,
            ),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: statusPaddingH,
            vertical: statusPaddingV,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(isTablet ? 10 : 6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: statusFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
