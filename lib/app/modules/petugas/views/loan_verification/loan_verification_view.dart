import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/petugas/widgets/loan_verification/verification_item.dart';
import 'package:flutter/material.dart';

class LoanVerificationView extends StatelessWidget {
  const LoanVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
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
                VerificationItem(
                  name: 'PJM-20260114-0001',
                  date: '12 Jan 2026',
                  color: Warna.ungu,
                ),
                SizedBox(height: 12),
                VerificationItem(
                  name: 'PJM-20260114-0002',
                  date: '13 Jan 2026',
                  color: Warna.ungu,
                ),
                SizedBox(height: 12),
                VerificationItem(
                  name: 'PJM-20260114-0003',
                  date: '14 Jan 2026',
                  color: Warna.ungu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
