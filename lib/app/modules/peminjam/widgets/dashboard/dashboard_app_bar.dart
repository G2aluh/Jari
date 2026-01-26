import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:benang_merah/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PeminjamDashboardController controller;

  const DashboardAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(
      () => AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: controller.isSearchActive.value
            ? TextField(
                controller: controller.searchController,
                autofocus: true,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  hintText: "Cari barang...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              )
            : ActionChip(
                label: Text("Peminjaman Barang"),
                labelStyle: TextStyle(color: Warna.putih),
                avatar: Icon(IconlyBold.scan, color: Warna.putih),
                shape: StadiumBorder(),
                side: BorderSide(width: 0),
                backgroundColor: Warna.hitamTransparan,
                onPressed: () {},
              ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => controller.toggleSearch(),
          icon: Icon(
            controller.isSearchActive.value
                ? Icons.arrow_back
                : IconlyLight.search,
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              authController.logout();
              Get.offAllNamed('/login');
            },
            icon: Icon(IconlyLight.logout),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
