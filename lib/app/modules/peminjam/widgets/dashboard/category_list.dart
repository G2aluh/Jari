import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';

class CategoryList extends StatelessWidget {
  final PeminjamDashboardController controller;

  const CategoryList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Optional: loading kategori
      if (controller.kategoriListDb.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Kategori Barang', style: AppTextStyles.primaryText),
            ),
            const SizedBox(
              height: 90,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('Kategori Barang', style: AppTextStyles.primaryText),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.kategoriListDb.length + 1, // +1 untuk Semua
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                // =========================
                // ITEM "SEMUA"
                // =========================
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      controller.filterByKategori('');
                    },
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.apps),
                          SizedBox(height: 8),
                          Text(
                            'Semua',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // =========================
                // ITEM KATEGORI (PASTI INDEX > 0)
                // =========================
                final Map<String, dynamic> kategori =
                    controller.kategoriListDb[index - 1];

                return GestureDetector(
                  onTap: () {
                    controller.filterByKategori(kategori['id']);
                  },
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Warna.hitamTransparan,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          buildIconFromDb(kategori),
                          size: 28,
                          color: Warna.putih,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          kategori['nama_kategori'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Warna.putih,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

IconData buildIconFromDb(Map<String, dynamic> kategori) {
  final int? code = kategori['icon_code'];
  final String? family = kategori['icon_family'];
  final String? package = kategori['icon_package'];

  if (code == null || family == null) {
    return Icons.category; // fallback aman
  }

  return IconData(code, fontFamily: family, fontPackage: package);
}
