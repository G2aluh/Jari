import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/widgets/return_monitoring/return_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class ReturnMonitoringView extends StatelessWidget {
  const ReturnMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetugasDashboardController>();

    return Container(
      padding: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

              final activeLoans = controller.activeLoans;
              final pendingReturns = controller.pendingReturns;

              return ListView(
                children: [
                  // Search Bar
                  TextField(
                    style: TextStyle(color: Warna.putih, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari pengembalian...',
                      hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      prefixIcon: Icon(
                        IconlyLight.search,
                        color: Warna.putih.withOpacity(0.5),
                        size: 16,
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
                    ),
                  ),
                  SizedBox(height: 16),
                  // Alert Informasi
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Warna.kuning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Warna.kuning.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(IconlyBold.infoSquare, color: Warna.kuning),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Informasi",
                                style: TextStyle(
                                  color: Warna.kuning,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Pilih Transaksi untuk melihat detail & konfirmasi pengembalian",
                                style: TextStyle(
                                  color: Warna.kuning.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Semua Transaksi',
                        style: AppTextStyles.primaryText.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (activeLoans.isEmpty && pendingReturns.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              IconlyBold.tickSquare,
                              size: 80,
                              color: Warna.abuAbu.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Tidak ada transaksi pengembalian",
                              style: TextStyle(color: Warna.abuAbu),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Show active loans with their return status
                    ...activeLoans.map((loan) {
                      final pengembalian = controller
                          .getPengembalianForPeminjaman(loan.id);
                      final hasPendingReturn = pengembalian != null;
                      final isLate =
                          loan.tanggalJatuhTempo != null &&
                          DateTime.now().isAfter(loan.tanggalJatuhTempo!);

                      String status;
                      Color statusColor;

                      if (hasPendingReturn) {
                        status = 'Menunggu';
                        statusColor = Colors.orange;
                      } else if (isLate) {
                        status = 'Terlambat';
                        statusColor = Colors.red;
                      } else {
                        status = 'Disetujui';
                        statusColor = Colors.green;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReturnItem(
                          loan: loan,
                          pengembalian: pengembalian,
                          controller: controller,
                          status: status,
                          statusColor: statusColor,
                        ),
                      );
                    }).toList(),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
