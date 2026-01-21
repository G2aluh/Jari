import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ActivityLogView extends StatelessWidget {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for logs
    final List<Map<String, dynamic>> logs = [
      {
        'action': 'Login berhasil',
        'user': 'Admin',
        'time': '1 Jan 2023, 10:30 AM',
        'icon': Icons.login,
        'color': Warna.ungu,
      },
      {
        'action': 'Penambahan alat baru',
        'user': 'Admin',
        'time': '1 Jan 2023, 11:15 AM',
        'icon': Icons.inventory_2,
        'color': Warna.kuning,
      },
      {
        'action': 'Penambahan pengguna baru',
        'user': 'Admin',
        'time': '1 Jan 2023, 11:45 AM',
        'icon': Icons.person_add,
        'color': Warna.putih,
      },
      {
        'action': 'Verifikasi peminjaman',
        'user': 'Petugas',
        'time': '1 Jan 2023, 1:20 PM',
        'icon': Icons.check_circle,
        'color': Warna.ungu,
      },
      {
        'action': 'Pengembalian alat',
        'user': 'Peminjam',
        'time': '1 Jan 2023, 3:45 PM',
        'icon': Icons.undo,
        'color': Warna.kuning,
      },
    ];

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Log Aktivitas',
            style: AppTextStyles.primaryText.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Lihat histori aktivitas pengguna dalam sistem',
            style: TextStyle(fontSize: 16, color: Warna.putih.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: logs.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = logs[index];
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: log['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(log['icon'], color: log['color']),
                    ),
                    title: Text(
                      log['action'],
                      style: TextStyle(
                        color: Warna.putih,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${log['user']} - ${log['time']}',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
