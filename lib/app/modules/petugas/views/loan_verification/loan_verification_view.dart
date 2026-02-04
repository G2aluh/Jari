import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/widgets/loan_verification/verification_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanVerificationView extends StatelessWidget {
  const LoanVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetugasDashboardController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
        final hPadding = isTablet ? 40.0 : 18.0;
        final maxWidth = isTablet ? 850.0 : double.infinity;
        final spacing = isTablet ? 24.0 : 16.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding,
                vertical: hPadding,
              ),
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
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        );
                      }

                      final pendingLoans = controller.pendingLoans;

                      return ListView(
                        children: [
                          // Search Bar
                          TextField(
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: isTablet ? 18 : 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari verifikasi...',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Verifikasi Peminjaman',
                                style: AppTextStyles.primaryText.copyWith(
                                  fontSize: isTablet ? 24 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 16 : 8),
                          if (pendingLoans.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: isTablet ? 80 : 50),
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
                                      "Tidak ada peminjaman yang perlu diverifikasi",
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
                            ...pendingLoans
                                .map(
                                  (loan) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isTablet ? 20 : 12,
                                    ),
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
            ),
          ),
        );
      },
    );
  }
}
