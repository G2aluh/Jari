import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/peminjam/widgets/common/stock_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class NewEquipmentSection extends StatelessWidget {
  final PeminjamDashboardController controller;

  const NewEquipmentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final alat = controller.alatTerbaru;
    if (alat == null) return const SizedBox.shrink();

    final int alatIndex = 0; // alat terbaru
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Alat Baru",
                style: AppTextStyles.barangTerbaikText.copyWith(fontSize: 22),
              ),
              SizedBox(width: 10),
              //NewContainer
              Container(
                padding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Warna.ungu,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text("New", style: AppTextStyles.stokText),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Warna.ungu.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Warna.putih,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    alat['alat_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          alat['nama_alat'],
                          style: AppTextStyles.namaBarangText,
                        ),
                        SizedBox(width: 4),
                        //Stok Container
                        StockContainer(stock: alat['stok_tersedia'].toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Sewa Sekarang! Sebelum Kehabisan",
                          style: AppTextStyles.produkBaruText,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
