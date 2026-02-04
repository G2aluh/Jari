import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
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
    final controller = Get.find<PeminjamDashboardController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Warna.hitamBackground,
      appBar: DashboardAppBar(controller: controller),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
          final hPadding = isTablet ? 40.0 : 16.0;
          final vPadding = isTablet ? 24.0 : 16.0;

          return CustomScrollView(
            slivers: [
              // Category List dengan responsive padding
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPadding,
                    vertical: vPadding,
                  ),
                  child: CategoryList(controller: controller),
                ),
              ),

              // Equipment & New Equipment Section
              Obx(() {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    margin: EdgeInsets.only(top: isTablet ? 16 : 10),
                    decoration: BoxDecoration(
                      color: Warna.putih,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(isTablet ? 28 : 20),
                      ),
                    ),
                    child: controller.isLoadingAlat.value
                        ? _buildLoadingState(context)
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
          );
        },
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

Widget _buildLoadingState(BuildContext context) {
  final isTablet = Responsive.isTablet(context);
  final cardWidth = isTablet ? 180.0 : 130.0;
  final cardHeight = isTablet ? 280.0 : 220.0;
  final spacing = isTablet ? 24.0 : 15.0;
  final padding = isTablet ? 40.0 : 24.0;

  return Padding(
    padding: EdgeInsets.all(padding),
    child: Column(
      children: [
        // loading equipment list
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(width: spacing),
            itemBuilder: (_, __) => Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
              ),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 32 : 24),

        // loading new equipment
        Container(
          height: isTablet ? 120 : 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
          ),
        ),
      ],
    ),
  );
}
