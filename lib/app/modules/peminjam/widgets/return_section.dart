import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnSection extends StatelessWidget {
  const ReturnSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Returns
    // Toggle this list to test empty vs populated state
    final List<Map<String, dynamic>> returns = [
      {
        'id': '#1023',
        'item': '2 Items',
        'status': 'Menunggu',
        'date': '21 Jan 2026',
      },
      {
        'id': '#1020',
        'item': '1 Item',
        'status': 'Selesai',
        'date': '18 Jan 2026',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengembalian Alat",
            style: AppTextStyles.barangTerbaikText.copyWith(fontSize: 22),
          ),
          SizedBox(height: 12),
          if (returns.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Warna.abuAbu.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Warna.abuAbu.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 48,
                    color: Warna.abuAbu.withOpacity(0.5),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Belum mengajukan pengembalian/penyewaan",
                    style: TextStyle(
                      color: Warna.abuAbu.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Column(
              children: returns
                  .map((returnItem) => _buildReturnCard(returnItem))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildReturnCard(Map<String, dynamic> returnItem) {
    Color statusColor = returnItem['status'] == 'Selesai'
        ? Colors.green
        : Colors.orange;

    return GestureDetector(
      onTap: () {
        // Navigate to loan detail (assuming reused detail view or new one)
        // For now using existing detail route if available, or placeholder
        Get.toNamed(Routes.detailRiwayatPeminjam);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Warna.putih,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Warna.abuAbu.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Warna.abuAbu.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.ungu.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.assignment_return, color: Warna.ungu),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengembalian ${returnItem['id']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Warna.hitamBackground,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${returnItem['item']} • ${returnItem['date']}",
                    style: TextStyle(color: Warna.abuAbu, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                returnItem['status'],
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
