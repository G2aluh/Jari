import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Manajemen Kategori', style: TextStyle(color: Warna.putih)),
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
            Icon(Icons.category, size: 80, color: Warna.ungu),
            SizedBox(height: 24),
            Text(
              'Manajemen Kategori',
              style: AppTextStyles.primaryText.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Tambah, edit, hapus, dan kelola kategori alat',
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
                'Tambah Kategori Baru',
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
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Warna.ungu.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.home_repair_service, color: Warna.ungu),
                    ),
                    title: Text(
                      'Peralatan Rumah Tangga',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      '12 alat',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
                      ],
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
                      child: Icon(Icons.construction, color: Warna.kuning),
                    ),
                    title: Text(
                      'Peralatan Bengkel',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      '8 alat',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
                      ],
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
                      child: Icon(Icons.design_services, color: Warna.putih),
                    ),
                    title: Text(
                      'Peralatan Desain',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      '5 alat',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Warna.putih),
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Edit')),
                        PopupMenuItem(child: Text('Hapus')),
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
