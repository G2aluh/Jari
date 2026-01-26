import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/petugas/widgets/return_monitoring/return_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReturnMonitoringView extends StatelessWidget {
  const ReturnMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                // Search Bar
                TextField(
                  style: TextStyle(color: Warna.putih),
                  decoration: InputDecoration(
                    hintText: 'Cari pengembalian...',
                    hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Warna.putih.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Warna.hitamTransparan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //Alert Informasi
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Warna.kuning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Warna.kuning.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(IconlyBold.infoSquare, color: Warna.kuning),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Informasi",
                              style: TextStyle(
                                color: Warna.kuning,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Pilih Transaksi untuk melihat detail & konfirmasi pengembalian",
                              style: TextStyle(
                                color: Warna.kuning.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                ReturnItem(
                  name: 'PJM-20260114-0001',
                  date: '15 Jan 2023',
                  status: 'Dipinjam',
                  statusColor: Colors.green,
                ),
                SizedBox(height: 12),
                ReturnItem(
                  name: 'PJM-20260114-0002',
                  date: '10 Jan 2023',
                  status: 'Terlambat',
                  statusColor: Colors.red,
                ),
                SizedBox(height: 12),
                ReturnItem(
                  name: 'PJM-20260114-0003',
                  date: '20 Jan 2023',
                  status: 'Dipinjam',
                  statusColor: Colors.green,
                ),
                SizedBox(height: 12),
                ReturnItem(
                  name: 'PJM-20260114-0004',
                  date: '25 Jan 2023',
                  status: 'Dipinjam',
                  statusColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
