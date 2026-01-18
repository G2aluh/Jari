import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ActivityLogView extends StatelessWidget {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Log Aktivitas', style: TextStyle(color: Warna.putih)),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => Get.back(),
          icon: Icon(IconlyLight.arrowLeft2),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.history, size: 80, color: Warna.ungu),
            SizedBox(height: 24),
            Text(
              'Log Aktivitas',
              style: AppTextStyles.primaryText.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Lihat histori aktivitas pengguna dalam sistem',
              style: TextStyle(
                fontSize: 16,
                color: Warna.putih.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
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
                      child: Icon(Icons.login, color: Warna.ungu),
                    ),
                    title: Text(
                      'Login berhasil',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Admin - 1 Jan 2023, 10:30 AM',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
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
                      child: Icon(Icons.inventory_2, color: Warna.kuning),
                    ),
                    title: Text(
                      'Penambahan alat baru',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Admin - 1 Jan 2023, 11:15 AM',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
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
                      child: Icon(Icons.person_add, color: Warna.putih),
                    ),
                    title: Text(
                      'Penambahan pengguna baru',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Admin - 1 Jan 2023, 11:45 AM',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                  ),
                  Divider(color: Warna.putih.withOpacity(0.2)),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Warna.ungu.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.check_circle, color: Warna.ungu),
                    ),
                    title: Text(
                      'Verifikasi peminjaman',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Petugas - 1 Jan 2023, 1:20 PM',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
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
                      child: Icon(Icons.undo, color: Warna.kuning),
                    ),
                    title: Text(
                      'Pengembalian alat',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Peminjam - 1 Jan 2023, 3:45 PM',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
