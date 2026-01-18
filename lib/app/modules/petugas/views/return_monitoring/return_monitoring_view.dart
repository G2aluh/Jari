import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:benang_merah/app/modules/petugas/views/return_monitoring/dialog/detail_pengembalian_dialog.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReturnMonitoringView extends StatelessWidget {
  const ReturnMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(IconlyBold.infoSquare, color: Warna.kuning),
                    SizedBox(width: 8),
                    Text(
                      'Klik transaksi untuk melihat detail',
                      style: AppTextStyles.primaryText.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Semua Transaksi',
                      style: AppTextStyles.primaryText.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                _buildReturnItem(
                  context,
                  'PJM-20260114-0001',
                  '15 Jan 2023',
                  'Dipinjam',
                  Colors.green,
                ),
                SizedBox(height: 12),
                _buildReturnItem(
                  context,
                  'PJM-20260114-0002',
                  '10 Jan 2023',
                  'Terlambat',
                  Colors.red,
                ),
                SizedBox(height: 12),
                _buildReturnItem(
                  context,
                  'PJM-20260114-0003',
                  '20 Jan 2023',
                  'Dipinjam',
                  Colors.green,
                ),
                SizedBox(height: 12),
                _buildReturnItem(
                  context,
                  'PJM-20260114-0004',
                  '25 Jan 2023',
                  'Dipinjam',
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnItem(
    BuildContext context,
    String name,
    String date,
    String status,
    Color statusColor,
  ) {
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
