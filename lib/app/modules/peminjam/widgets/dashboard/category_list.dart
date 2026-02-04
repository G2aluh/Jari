import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';

class CategoryList extends StatelessWidget {
  final PeminjamDashboardController controller;

  const CategoryList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Tablet sizing yang lebih besar
    final itemWidth = isTablet ? 110.0 : 90.0;
    final itemHeight = isTablet ? 110.0 : 90.0;
    final iconSize = isTablet ? 36.0 : 28.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final fontSize = isTablet ? 14.0 : 12.0;
    final titleSize = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 24.0 : 20.0;
    final itemPadding = isTablet ? 8.0 : 4.0;

    return Obx(() {
      // Optional: loading kategori
      if (controller.kategoriListDb.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Kategori Barang',
                style: AppTextStyles.primaryText.copyWith(fontSize: titleSize),
              ),
            ),
            SizedBox(
              height: itemHeight,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 16.0 : 8.0),
            child: Text(
              'Kategori Barang',
              style: AppTextStyles.primaryText.copyWith(fontSize: titleSize),
            ),
          ),
          SizedBox(
            height: itemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.kategoriListDb.length + 1, // +1 untuk Semua
              separatorBuilder: (_, __) => SizedBox(width: spacing),
              itemBuilder: (context, index) {
                return Obx(() {
                  // =========================
                  // ITEM "SEMUA"
                  // =========================
                  if (index == 0) {
                    final isSelected =
                        controller.selectedKategoriId.value.isEmpty;
                    return GestureDetector(
                      onTap: () {
                        controller.filterByKategori('');
                      },
                      child: Container(
                        width: itemWidth,
                        padding: EdgeInsets.all(itemPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: isSelected
                              ? Warna.ungu
                              : Warna.hitamTransparan,
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps,
                              color: Warna.putih,
                              size: iconSize,
                            ),
                            SizedBox(height: isTablet ? 10 : 8),
                            Text(
                              'Semua',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Warna.putih,
                                fontWeight: FontWeight.w500,
                              ),
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
                  final isSelected =
                      controller.selectedKategoriId.value == kategori['id'];

                  return GestureDetector(
                    onTap: () {
                      controller.filterByKategori(kategori['id']);
                    },
                    child: Container(
                      width: itemWidth,
                      padding: EdgeInsets.all(itemPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: isSelected ? Warna.ungu : Warna.hitamTransparan,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Warna.putih.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            buildIconFromDb(kategori),
                            size: iconSize,
                            color: Warna.putih,
                          ),
                          SizedBox(height: isTablet ? 10 : 8),
                          Text(
                            kategori['nama_kategori'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Warna.putih,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
