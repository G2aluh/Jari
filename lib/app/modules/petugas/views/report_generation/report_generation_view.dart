import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/petugas/widgets/report_generation/history_item.dart';
import 'package:benang_merah/app/modules/petugas/widgets/report_generation/report_item.dart';
import 'package:flutter/material.dart';

class ReportGenerationView extends StatelessWidget {
  const ReportGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search/Filter (Visual placeholder for consistency)
          TextField(
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari laporan...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          SizedBox(height: 16),

          Text(
            "Jenis Laporan",
            style: TextStyle(
              color: Warna.putih,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                ReportItem(
                  icon: Icons.today,
                  title: 'Laporan Harian',
                  subtitle: 'Rekap transaksi hari ini',
                  color: Warna.ungu,
                  onTap: () {},
                ),
                ReportItem(
                  icon: Icons.date_range,
                  title: 'Laporan Mingguan',
                  subtitle: 'Rekap transaksi minggu ini',
                  color: Warna.kuning,
                  onTap: () {},
                ),
                ReportItem(
                  icon: Icons.calendar_month,
                  title: 'Laporan Bulanan',
                  subtitle: 'Rekap transaksi bulan ini',
                  color: Colors.teal,
                  onTap: () {},
                ),
                SizedBox(height: 24),
                Text(
                  "Riwayat Unduhan",
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                HistoryItem(
                  title: 'Laporan Peminjaman Jan 2026',
                  date: '21 Jan 2026',
                  type: 'Bulanan',
                ),
                HistoryItem(
                  title: 'Laporan Aktivitas Minggu #3',
                  date: '18 Jan 2026',
                  type: 'Mingguan',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
