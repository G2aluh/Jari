import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/widgets/loan_verification/verification_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanVerificationView extends StatelessWidget {
  const LoanVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetugasDashboardController>();

    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoadingLoans.value) {
                return Center(
                  child: CircularProgressIndicator(color: Warna.ungu),
                );
              }

              if (controller.errorLoans.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorLoans.value,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final pendingLoans = controller.pendingLoans;

              return ListView(
                children: [
                  // Search Bar
                  TextField(
                    style: TextStyle(color: Warna.putih),
                    decoration: InputDecoration(
                      hintText: 'Cari verifikasi...',
                      hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      prefixIcon: Icon(
                        Icons.search,
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
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Verifikasi Peminjaman',
                        style: AppTextStyles.primaryText.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (pendingLoans.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Warna.abuAbu.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Tidak ada peminjaman yang perlu diverifikasi",
                              style: TextStyle(color: Warna.abuAbu),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...pendingLoans
                        .map(
                          (loan) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: VerificationItem(
                              loan: loan,
                              controller: controller,
                            ),
                          ),
                        )
                        .toList(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
