import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/category_list.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/dashboard_app_bar.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/equipment_list.dart';
import 'package:benang_merah/app/modules/peminjam/widgets/new_equipment_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:benang_merah/app/routes/app_routes.dart';

class PeminjamDashboardView extends StatelessWidget {
  const PeminjamDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(PeminjamDashboardController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Warna.hitamBackground,
      appBar: DashboardAppBar(controller: controller),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const CategoryList(),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.67,
            ),
            decoration: BoxDecoration(
              color: Warna.putih,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                EquipmentList(controller: controller),
                NewEquipmentSection(controller: controller),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Warna.putih,
        selectedItemColor: Warna.ungu,
        unselectedItemColor: Warna.hitamBackground.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          if (value == 1) {
            Get.toNamed(Routes.riwayatPeminjam);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.category),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              alignment: Alignment(1, -1.5),
              backgroundColor: Warna.ungu,
              child: Icon(IconlyBold.timeCircle),
            ),
            label: "Riwayat",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() {
        final showBadge = controller.showBadge.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Warna.ungu.withOpacity(0.2), spreadRadius: 5),
            ],
          ),
          child: showBadge
              ? Badge(
                  alignment: Alignment(1.2, -1.2),
                  backgroundColor: Warna.ungu,
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () =>
                        controller.showRentalSelectionDialog(context),
                    backgroundColor: Warna.ungu,
                    foregroundColor: Warna.putih,
                    child: Icon(Icons.add),
                  ),
                )
              : FloatingActionButton(
                  elevation: 0,
                  onPressed: () =>
                      controller.showRentalSelectionDialog(context),
                  backgroundColor: Warna.ungu,
                  foregroundColor: Warna.putih,
                  child: Icon(Icons.add),
                ),
        );
      }),
    );
  }
}
