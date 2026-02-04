import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/peminjam/widgets/dashboard/category_list.dart';
import 'package:jari/app/modules/peminjam/widgets/dashboard/dashboard_app_bar.dart';
import 'package:jari/app/modules/peminjam/widgets/dashboard/equipment_list.dart';
import 'package:jari/app/modules/peminjam/widgets/dashboard/new_equipment_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class PeminjamDashboardView extends StatelessWidget {
  const PeminjamDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.find<PeminjamDashboardController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Warna.hitamBackground,
      appBar: DashboardAppBar(controller: controller),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CategoryList(controller: controller),
            ),
          ),

          Obx(() {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Warna.putih,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: controller.isLoadingAlat.value
                    ? _buildLoadingState()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EquipmentList(controller: controller),
                          NewEquipmentSection(controller: controller),
                        ],
                      ),
              ),
            );
          }),
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
            controller.showHistorySelectionDialog(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.category),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.timeCircle),
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
                    hoverElevation: 0,
                    splashColor: Colors.transparent,
                    highlightElevation: 0,
                    hoverColor: Colors.transparent,
                    onPressed: () =>
                        controller.showRentalSelectionDialog(context),
                    backgroundColor: Warna.ungu,
                    foregroundColor: Warna.putih,
                    child: Icon(Icons.add),
                  ),
                )
              : FloatingActionButton(
                  elevation: 0,
                  hoverElevation: 0,
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

Widget _buildLoadingState() {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        // loading equipment list
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (_, __) => Container(
              width: 130,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // loading new equipment
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    ),
  );
}
