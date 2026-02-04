import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/peminjam/widgets/common/stock_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class EquipmentList extends StatelessWidget {
  final PeminjamDashboardController controller;

  const EquipmentList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Alat Untuk Disewa",
                style: AppTextStyles.barangTerbaikText,
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(IconlyLight.infoSquare),
                label: Text("Geser"),
              ),
            ],
          ),
        ),
        Obx(() {
          // =========================
          // EMPTY STATE
          // =========================
          if (controller.alatList.isEmpty) {
            final kategoriNama = controller.selectedKategoriNama;

            return SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  kategoriNama.isNotEmpty
                      ? 'Tidak ada alat untuk kategori $kategoriNama'
                      : 'Tidak ada alat tersedia',
                  style: AppTextStyles.primaryText.copyWith(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // =========================
          // LIST WITH ITEMS
          // =========================
          return SizedBox(
            height: 220,
            child: ListView.separated(
              padding: EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final alat = controller.alatList[index];
                final isRented = controller.rentedItems.contains(index);

                return SizedBox(
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =====================
                      // GAMBAR + STOK + NAMA
                      // =====================
                      Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: NetworkImage(alat['alat_url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              right: 8,
                              child: StockContainer(
                                stock: alat['stok_tersedia'].toString(),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  alat['nama_alat'],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.namaBarangText.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // =====================
                      // BUTTON (TANPA Obx)
                      // =====================
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          backgroundColor: isRented ? Colors.grey : Warna.ungu,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => controller.toggleRent(index),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isRented ? "Disewa" : "Sewa",
                              style: AppTextStyles.stokText,
                            ),
                            const SizedBox(width: 5),
                            Icon(IconlyBold.bag, size: 16, color: Warna.putih),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },

              separatorBuilder: (context, index) => SizedBox(width: 15),
              itemCount: controller.alatList.length,
            ),
          );
        }),
      ],
    );
  }
}
