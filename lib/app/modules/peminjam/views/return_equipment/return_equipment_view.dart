import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReturnEquipmentView extends StatefulWidget {
  const ReturnEquipmentView({super.key});

  @override
  State<ReturnEquipmentView> createState() => _ReturnEquipmentViewState();
}

class _ReturnEquipmentViewState extends State<ReturnEquipmentView> {
  final controller = Get.find<PeminjamDashboardController>();

  @override
  void initState() {
    super.initState();
    controller.fetchActiveLoansForReturn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Pengembalian Alat', style: TextStyle(color: Warna.putih)),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => Get.back(),
          icon: Icon(IconlyLight.arrowLeft2),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoadingReturns.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Warna.ungu),
                  );
                }

                if (controller.errorReturns.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorReturns.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final returnList = controller.activeLoansForReturn;

                return ListView(
                  children: [
                    SizedBox(height: 16),
                    // Search Bar
                    TextField(
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        hintText: 'Cari pengembalian...',
                        hintStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          IconlyLight.search,
                          color: Warna.putih.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Warna.hitamTransparan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Warna.ungu),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Late Item Alert - Dynamic
                    Obx(() {
                      final lateCount = controller.lateItemsCount;
                      if (lateCount > 0) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(IconlyBold.danger, color: Colors.red),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Peringatan Barang Terlambat",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Anda memiliki $lateCount barang yang belum dikembalikan melewati batas waktu.",
                                      style: TextStyle(
                                        color: Colors.red.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                    SizedBox(height: 24),

                    // List Items
                    if (returnList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_turned_in_outlined,
                                size: 80,
                                color: Warna.abuAbu.withOpacity(0.5),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Tidak ada barang yang perlu dikembalikan",
                                style: TextStyle(color: Warna.abuAbu),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...returnList
                          .map((loan) => _buildReturnCard(loan))
                          .toList(),
                    SizedBox(height: 24),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnCard(Peminjaman loan) {
    final isLate = controller.isLoanLate(loan);
    final status = isLate ? 'Terlambat' : 'Disetujui';

    return FutureBuilder<Map<String, dynamic>?>(
      future: controller.getPengembalianStatus(loan.id),
      builder: (context, snapshot) {
        final pengembalian = snapshot.data;
        final hasPendingReturn = pengembalian != null;
        final pengembalianStatus = pengembalian?['status'] as String?;
        final hasRejection =
            loan.catatanPenolakan != null && loan.catatanPenolakan!.isNotEmpty;

        String displayStatus = status;
        if (hasPendingReturn) {
          displayStatus = pengembalianStatus == 'menunggu'
              ? 'Menunggu Konfirmasi'
              : 'Selesai';
        }

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Warna.hitamTransparan,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Warna.putih.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Warna.ungu.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.inventory_2_outlined, color: Warna.ungu),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                loan.kodePeminjaman ?? loan.id.substring(0, 8),
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Note icon for rejection reason
                            if (hasRejection)
                              IconButton(
                                icon: Icon(Icons.note, color: Colors.orange),
                                onPressed: () => _showRejectionReasonDialog(
                                  loan.catatanPenolakan!,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(displayStatus).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      displayStatus,
                      style: TextStyle(
                        color: _getTextColor(displayStatus),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1, color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tgl Peminjaman",
                    style: TextStyle(color: Warna.putih.withOpacity(0.8)),
                  ),
                  Text(
                    loan.tanggalPinjamFormatted,
                    style: TextStyle(
                      color: Warna.putih,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Batas Kembali",
                    style: TextStyle(color: Warna.putih.withOpacity(0.8)),
                  ),
                  Text(
                    loan.tanggalJatuhTempoFormatted,
                    style: TextStyle(
                      color: isLate ? Colors.red : Warna.putih,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasPendingReturn
                        ? Warna.abuAbu
                        : Warna.ungu,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: hasPendingReturn
                      ? null
                      : () => controller.submitReturnRequest(loan.id),
                  child: Text(
                    hasPendingReturn
                        ? "Menunggu Konfirmasi"
                        : "Kembalikan Barang",
                    style: TextStyle(
                      color: Warna.putih,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRejectionReasonDialog(String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              "Alasan Penolakan",
              style: TextStyle(color: Warna.putih, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          reason,
          style: TextStyle(color: Warna.putih.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tutup", style: TextStyle(color: Warna.ungu)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return Colors.blue;
      case 'Terlambat':
        return Colors.red;
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Warna.ungu;
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Disetujui':
        return Colors.blue;
      case 'Terlambat':
        return Colors.red;
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Warna.ungu;
    }
  }
}
