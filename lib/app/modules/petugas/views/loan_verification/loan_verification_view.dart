import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
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
                _buildVerificationItem(
                  context,
                  'PJM-20260114-0001',
                  '12 Jan 2026',
                  Warna.ungu,
                ),
                SizedBox(height: 12),
                _buildVerificationItem(
                  context,
                  'PJM-20260114-0002',
                  '13 Jan 2026',
                  Warna.ungu,
                ),
                SizedBox(height: 12),
                _buildVerificationItem(
                  context,
                  'PJM-20260114-0003',
                  '14 Jan 2026',
                  Warna.ungu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(
    BuildContext context,
    String name,
    String date,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(color: Warna.putih)),
        subtitle: Text(
          'Tanggal: $date',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check, color: Colors.green),
            ),
            IconButton(
              onPressed: () => _showRejectionDialog(context),
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Warna.abuAbu,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Penolakan",
                style: AppTextStyles.primaryText.copyWith(
                  fontSize: 18,
                  color: Warna.putih,
                ),
                textAlign: TextAlign.start,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Warna.putih),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Masukkan alasan penolakan",
                style: TextStyle(color: Warna.putih.withOpacity(0.7)),
              ),
              SizedBox(height: 8),
              TextField(
                style: TextStyle(color: Warna.putih),
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Warna.hitamBackground,
                  hintText: "Contoh: Stok alat tidak mencukupi",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Handle rejection logic here
                      Navigator.pop(context);
                    },
                    child: Text("Tolak", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
