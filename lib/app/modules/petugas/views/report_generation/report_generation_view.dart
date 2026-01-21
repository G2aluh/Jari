import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
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
                _buildReportItem(
                  icon: Icons.today,
                  title: 'Laporan Harian',
                  subtitle: 'Rekap transaksi hari ini',
                  color: Warna.ungu,
                  onTap: () {},
                ),
                _buildReportItem(
                  icon: Icons.date_range,
                  title: 'Laporan Mingguan',
                  subtitle: 'Rekap transaksi minggu ini',
                  color: Warna.kuning,
                  onTap: () {},
                ),
                _buildReportItem(
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
                _buildHistoryItem(
                  title: 'Laporan Peminjaman Jan 2026',
                  date: '21 Jan 2026',
                  type: 'Bulanan',
                ),
                _buildHistoryItem(
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

  Widget _buildReportItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.putih.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.print, color: Warna.putih.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String type,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.putih.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Warna.abuAbu, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Warna.putih,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$type • $date",
                  style: TextStyle(
                    color: Warna.putih.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.download_done, color: Warna.ungu, size: 20),
        ],
      ),
    );
  }
}
