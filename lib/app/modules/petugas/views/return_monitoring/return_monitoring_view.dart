import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
        final hPadding = isTablet ? 40.0 : 24.0;
        final maxWidth = isTablet ? 850.0 : double.infinity;
        final spacing = isTablet ? 24.0 : 16.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: EdgeInsets.only(
                top: 0,
                left: hPadding,
                right: hPadding,
                bottom: hPadding,
              ),
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
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        );
                      }

                      final activeLoans = controller.activeLoans;
                      final pendingReturns = controller.pendingReturns;

                      return ListView(
                        children: [
                          // Search Bar
                          TextField(
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
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16,
                                vertical: isTablet ? 20 : 12,
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
                            ),
                          ),
                          SizedBox(height: spacing),

                          // Alert Informasi
                          Container(
                            padding: EdgeInsets.all(isTablet ? 20 : 12),
                            decoration: BoxDecoration(
                              color: Warna.kuning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 16 : 12,
                              ),
                              border: Border.all(
                                color: Warna.kuning.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  IconlyBold.infoSquare,
                                  color: Warna.kuning,
                                  size: isTablet ? 32 : 24,
                                ),
                                SizedBox(width: isTablet ? 16 : 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Informasi",
                                        style: TextStyle(
                                          color: Warna.kuning,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isTablet ? 18 : 14,
                                        ),
                                      ),
                                      SizedBox(height: isTablet ? 6 : 4),
                                      Text(
                                        "Pilih Transaksi untuk melihat detail & konfirmasi pengembalian",
                                        style: TextStyle(
                                          color: Warna.kuning.withOpacity(0.8),
                                          fontSize: isTablet ? 16 : 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 16 : 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Semua Transaksi',
                                style: AppTextStyles.primaryText.copyWith(
                                  fontSize: isTablet ? 24 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 16 : 8),
                          if (activeLoans.isEmpty && pendingReturns.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: isTablet ? 60 : 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      IconlyBold.tickSquare,
                                      size: isTablet ? 120 : 80,
                                      color: Warna.abuAbu.withOpacity(0.5),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 16),
                                    Text(
                                      "Tidak ada transaksi pengembalian",
                                      style: TextStyle(
                                        color: Warna.abuAbu,
                                        fontSize: isTablet ? 18 : 14,
                                      ),
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
                                  DateTime.now().isAfter(
                                    loan.tanggalJatuhTempo!,
                                  );

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
                                padding: EdgeInsets.only(
                                  bottom: isTablet ? 20 : 12,
                                ),
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
            ),
          ),
        );
      },
    );
  }
}
