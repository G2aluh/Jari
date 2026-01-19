import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/petugas/views/return_monitoring/dialog/detail_pengembalian_dialog.dart';
import 'package:flutter/material.dart';

class ReturnItem extends StatelessWidget {
  final String name;
  final String date;
  final String status;
  final Color statusColor;

  const ReturnItem({
    super.key,
    required this.name,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const DetailPengembalianDialog(),
          );
        },
        contentPadding: EdgeInsets.all(16),
        title: Text(name, style: TextStyle(color: Warna.putih)),
        subtitle: Text(
          'Harus kembali: $date',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: TextStyle(color: statusColor)),
        ),
      ),
    );
  }
}
