import 'package:jari/app/core/theme/app_colors.dart';
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
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        children: [
          // Search Input
          TextField(
            onChanged: controller.searchPeminjaman,
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Peminjaman',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

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
                        size: 64,
                        color: Warna.putih.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data peminjaman',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 16,
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
