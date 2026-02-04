import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_return_controller.dart';
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
  final controller = Get.find<PeminjamReturnController>();

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
          final hPadding = isTablet ? 40.0 : 24.0;
          final maxWidth = isTablet ? 850.0 : double.infinity;
          final spacing = isTablet ? 24.0 : 16.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
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
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          );
                        }

                        final returnList =
                            controller.filteredActiveLoansForReturn;

                        return ListView(
                          children: [
                            SizedBox(height: spacing),
                            // Search Bar
                            TextField(
                              controller: controller.searchReturnController,
                              style: TextStyle(
                                color: Warna.putih,
                                fontSize: isTablet ? 18 : 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Cari pengembalian...',
                                hintStyle: TextStyle(
                                  color: Warna.putih.withOpacity(0.5),
                                  fontSize: isTablet ? 18 : 14,
                                ),
                                prefixIcon: Icon(
                                  IconlyLight.search,
                                  color: Warna.putih.withOpacity(0.5),
                                  size: isTablet ? 24 : 16,
                                ),
                                filled: true,
                                fillColor: Warna.hitamTransparan,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 16 : 12,
                                  ),
                                  borderSide: BorderSide(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 16 : 12,
                                  ),
                                  borderSide: BorderSide(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 16 : 12,
                                  ),
                                  borderSide: BorderSide(
                                    color: Warna.ungu,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 20 : 16,
                                  vertical: isTablet ? 20 : 12,
                                ),
                              ),
                            ),
                            SizedBox(height: spacing),

                            // Late Item Alert - Dynamic
                            Obx(() {
                              final lateCount = controller.lateItemsCount;
                              if (lateCount > 0) {
                                return Container(
                                  padding: EdgeInsets.all(isTablet ? 20 : 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 16 : 12,
                                    ),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        IconlyBold.danger,
                                        color: Colors.red,
                                        size: isTablet ? 32 : 24,
                                      ),
                                      SizedBox(width: isTablet ? 16 : 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Peringatan Barang Terlambat",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isTablet ? 18 : 14,
                                              ),
                                            ),
                                            SizedBox(height: isTablet ? 6 : 4),
                                            Text(
                                              "Anda memiliki $lateCount barang yang belum dikembalikan melewati batas waktu.",
                                              style: TextStyle(
                                                color: Colors.red.withOpacity(
                                                  0.8,
                                                ),
                                                fontSize: isTablet ? 16 : 12,
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
                            SizedBox(height: isTablet ? 32 : 24),

                            // List Items
                            if (returnList.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: isTablet ? 60 : 40,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        IconlyLight.document,
                                        size: isTablet ? 120 : 80,
                                        color: Warna.abuAbu.withOpacity(0.5),
                                      ),
                                      SizedBox(height: isTablet ? 24 : 16),
                                      Text(
                                        "Tidak ada barang yang perlu dikembalikan",
                                        style: TextStyle(
                                          color: Warna.abuAbu,
                                          fontSize: isTablet ? 18 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ...returnList
                                  .map(
                                    (loan) => _buildReturnCard(loan, isTablet),
                                  )
                                  .toList(),
                            SizedBox(height: isTablet ? 32 : 24),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReturnCard(Peminjaman loan, bool isTablet) {
    final isLate = controller.isLoanLate(loan);
    final status = isLate ? 'Terlambat' : 'Disetujui';
    final cardPadding = isTablet ? 24.0 : 16.0;
    final cardMargin = isTablet ? 20.0 : 12.0;
    final titleSize = isTablet ? 20.0 : 16.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final valueSize = isTablet ? 16.0 : 14.0;
    final statusSize = isTablet ? 14.0 : 12.0;
    final iconSize = isTablet ? 32.0 : 24.0;
    final buttonPadding = isTablet ? 18.0 : 12.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;

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
              ? 'Menunggu'
              : 'Selesai';
        }

        return Container(
          margin: EdgeInsets.only(bottom: cardMargin),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: Warna.hitamTransparan,
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            border: Border.all(color: Warna.putih.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 14 : 10),
                    decoration: BoxDecoration(
                      color: Warna.ungu.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: Warna.ungu,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
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
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (hasRejection)
                          IconButton(
                            icon: Icon(
                              Icons.note,
                              color: Warna.kuning,
                              size: isTablet ? 24 : 20,
                            ),
                            onPressed: () => _showRejectionReasonDialog(
                              loan.catatanPenolakan!,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 8,
                      vertical: isTablet ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(displayStatus).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                    ),
                    child: Text(
                      displayStatus,
                      style: TextStyle(
                        color: _getTextColor(displayStatus),
                        fontSize: statusSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: isTablet ? 36 : 24,
                thickness: 1,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tgl Peminjaman",
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.8),
                      fontSize: labelSize,
                    ),
                  ),
                  Text(
                    loan.tanggalPinjamFormatted,
                    style: TextStyle(
                      color: Warna.putih,
                      fontWeight: FontWeight.w500,
                      fontSize: valueSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Batas Kembali",
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.8),
                      fontSize: labelSize,
                    ),
                  ),
                  Text(
                    loan.tanggalJatuhTempoFormatted,
                    style: TextStyle(
                      color: isLate ? Colors.red : Warna.putih,
                      fontWeight: FontWeight.w500,
                      fontSize: valueSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 24 : 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasPendingReturn
                        ? Warna.abuAbu
                        : Warna.ungu,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
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
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.w600,
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
    final isTablet = Responsive.isTablet(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        contentPadding: EdgeInsets.all(isTablet ? 24 : 20),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange,
              size: isTablet ? 28 : 20,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              "Alasan Penolakan",
              style: TextStyle(
                color: Warna.putih,
                fontSize: isTablet ? 22 : 18,
              ),
            ),
          ],
        ),
        content: Text(
          reason,
          style: TextStyle(
            color: Warna.putih.withOpacity(0.8),
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Tutup",
              style: TextStyle(color: Warna.ungu, fontSize: isTablet ? 16 : 14),
            ),
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
      case 'Menunggu':
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
      case 'Menunggu':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Warna.ungu;
    }
  }
}
