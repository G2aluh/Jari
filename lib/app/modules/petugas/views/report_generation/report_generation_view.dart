import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReportGenerationView extends StatelessWidget {
  const ReportGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.print, size: 80, color: Warna.ungu),
          SizedBox(height: 24),
          Text(
            'Cetak Laporan',
            style: AppTextStyles.primaryText.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Generate dan cetak laporan peminjaman dan pengembalian',
            style: TextStyle(fontSize: 16, color: Warna.putih.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Warna.ungu,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cetak Laporan Harian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Warna.putih,
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Warna.kuning,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cetak Laporan Mingguan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Warna.hitamBackground,
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Warna.putih,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cetak Laporan Bulanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Warna.hitamBackground,
              ),
            ),
          ),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Warna.ungu.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.description, color: Warna.ungu),
                  ),
                  title: Text(
                    'Laporan Peminjaman',
                    style: TextStyle(color: Warna.putih),
                  ),
                  subtitle: Text(
                    '15 Jan 2023 - 17 Jan 2023',
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                  trailing: Icon(Icons.download, color: Warna.putih),
                ),
                Divider(color: Warna.putih.withOpacity(0.2)),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Warna.kuning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.bar_chart, color: Warna.kuning),
                  ),
                  title: Text(
                    'Laporan Aktivitas',
                    style: TextStyle(color: Warna.putih),
                  ),
                  subtitle: Text(
                    'Januari 2023',
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                  trailing: Icon(Icons.download, color: Warna.putih),
                ),
                Divider(color: Warna.putih.withOpacity(0.2)),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Warna.putih.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.inventory_2, color: Warna.putih),
                  ),
                  title: Text(
                    'Laporan Alat',
                    style: TextStyle(color: Warna.putih),
                  ),
                  subtitle: Text(
                    'Status ketersediaan',
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                  trailing: Icon(Icons.download, color: Warna.putih),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
