import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReturnEquipmentView extends StatelessWidget {
  const ReturnEquipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Pengembalian Alat', style: TextStyle(color: Warna.putih)),
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
            Icon(Icons.undo, size: 80, color: Warna.ungu),
            SizedBox(height: 24),
            Text(
              'Pengembalian Alat',
              style: AppTextStyles.primaryText.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Kembalikan alat yang telah dipinjam',
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
                      child: Icon(Icons.inventory, color: Warna.ungu),
                    ),
                    title: Text(
                      'Mesin Jahit',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Harus kembali: 15 Jan 2023',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembalikan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Warna.putih,
                        ),
                      ),
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
                      child: Icon(Icons.build, color: Warna.kuning),
                    ),
                    title: Text(
                      'Obeng Set',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Harus kembali: 10 Jan 2023',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembalikan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Warna.putih,
                        ),
                      ),
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
                      child: Icon(
                        Icons.miscellaneous_services,
                        color: Warna.putih,
                      ),
                    ),
                    title: Text(
                      'Gerinda Tangan',
                      style: TextStyle(color: Warna.putih),
                    ),
                    subtitle: Text(
                      'Harus kembali: 20 Jan 2023',
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembalikan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Warna.putih,
                        ),
                      ),
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
