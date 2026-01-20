import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:benang_merah/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/stock_container.dart';
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
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: EdgeInsets.only(left: 16, right: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final alat = alatList[index];

              //Card Alat
              return SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //GAMBAR
                    Container(
                      width: double.maxFinite,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200,
                        image: DecorationImage(image: AssetImage(alat.gambar)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Stok
                            StockContainer(stock: alat.stok),
                          ],
                        ),
                      ),
                    ),

                    //NAMA BARANG
                    Text(alat.nama, style: AppTextStyles.namaBarangText),
                    SizedBox(height: 2),
                    //Sewa Button
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          backgroundColor:
                              controller.rentedItems.contains(index)
                              ? Colors.grey
                              : Warna.ungu,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => controller.toggleRent(index),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.rentedItems.contains(index)
                                  ? "Disewa"
                                  : "Sewa",
                              style: AppTextStyles.stokText,
                            ),
                            SizedBox(width: 5),
                            Icon(IconlyBold.bag, size: 16, color: Warna.putih),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemCount: alatList.length,
          ),
        ),
      ],
    );
  }
}
