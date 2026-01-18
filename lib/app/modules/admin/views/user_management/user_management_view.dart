import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Manajemen Pengguna', style: TextStyle(color: Warna.putih)),
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
            Icon(Icons.people_alt, size: 80, color: Warna.ungu),
            SizedBox(height: 24),
            Text(
              'Manajemen Pengguna',
              style: AppTextStyles.primaryText.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Tambah, edit, hapus, dan kelola akun pengguna',
              style: TextStyle(
                fontSize: 16,
                color: Warna.putih.withOpacity(0.7),
              ),
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
                'Tambah Pengguna Baru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Warna.putih,
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Warna.hitamTransparan,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Warna.ungu.withOpacity(0.2),
                      child: Icon(Icons.person, color: Warna.ungu),
                    ),
                    title: Text(
                      'Admin Utama',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'admin@example.com',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
                        PopupMenuItem(child: Text('Reset Password')),
                      ],
                    ),
                  ),
                  Divider(color: Warna.putih.withOpacity(0.2)),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Warna.kuning.withOpacity(0.2),
                      child: Icon(Icons.person, color: Warna.kuning),
                    ),
                    title: Text(
                      'Petugas 1',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'petugas1@example.com',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
                        PopupMenuItem(child: Text('Reset Password')),
                      ],
                    ),
                  ),
                  Divider(color: Warna.putih.withOpacity(0.2)),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Warna.putih.withOpacity(0.2),
                      child: Icon(Icons.person, color: Warna.putih),
                    ),
                    title: Text(
                      'Peminjam 1',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'peminjam1@example.com',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
                        PopupMenuItem(child: Text('Reset Password')),
                      ],
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
