import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/peminjaman_controller.dart';
import 'package:jari/app/modules/admin/widgets/loan/add_peminjaman_dialog.dart';
import 'package:jari/app/modules/admin/widgets/loan/delete_loan_dialog.dart';
import 'package:jari/app/modules/admin/widgets/loan/edit_loan_dialog.dart';
import 'package:jari/app/modules/admin/widgets/loan/loan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanManagementView extends StatelessWidget {
  LoanManagementView({super.key});

  final PeminjamanController controller = Get.put(PeminjamanController());

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final padding = isTablet ? 32.0 : 24.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final emptyIconSize = isTablet ? 80.0 : 64.0;
    final emptyTextSize = isTablet ? 18.0 : 16.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 14.0 : 12.0;

    return Container(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Column(
        children: [
          // Search Input
          TextField(
            onChanged: controller.searchPeminjaman,
            style: TextStyle(color: Warna.putih, fontSize: inputFontSize),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(
                color: Warna.putih.withOpacity(0.5),
                fontSize: inputFontSize,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
                size: iconSize,
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 18 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.ungu, width: 2),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              icon: Icon(Icons.add, color: Colors.white, size: iconSize),
              label: Text(
                'Tambah Peminjaman',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: buttonFontSize,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Warna.ungu),
                );
              }

              if (controller.filteredPeminjamanList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: emptyIconSize,
                        color: Warna.putih.withOpacity(0.3),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Belum ada data peminjaman',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: emptyTextSize,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredPeminjamanList.length,
                itemBuilder: (context, index) {
                  final peminjaman = controller.filteredPeminjamanList[index];
                  return LoanCard(
                    peminjaman: peminjaman,
                    onEdit: () => _showEditDialog(context, peminjaman),
                    onDelete: () => _showDeleteDialog(context, peminjaman),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPeminjamanDialog(controller: controller),
    );
  }

  void _showEditDialog(BuildContext context, peminjaman) {
    showDialog(
      context: context,
      builder: (context) =>
          EditLoanDialog(peminjaman: peminjaman, controller: controller),
    );
  }

  void _showDeleteDialog(BuildContext context, peminjaman) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteLoanDialog(peminjaman: peminjaman, controller: controller),
    );
  }
}
