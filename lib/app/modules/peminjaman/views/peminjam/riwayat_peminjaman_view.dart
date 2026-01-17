import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class RiwayatPeminjamanView extends StatelessWidget {
  const RiwayatPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> riwayatList = [
      {
        'no': '1',
        'tglPeminjaman': '12/01/2026',
        'status': 'Menunggu',
        'tglKembali': '15/01/2026',
      },
      {
        'no': '2',
        'tglPeminjaman': '10/01/2026',
        'status': 'Selesai',
        'tglKembali': '13/01/2026',
      },
      {
        'no': '3',
        'tglPeminjaman': '05/01/2026',
        'status': 'Dibatalkan',
        'tglKembali': '-',
      },
      {
        'no': '4',
        'tglPeminjaman': '02/01/2026',
        'status': 'Menunggu',
        'tglKembali': '06/01/2026',
      },
    ];

    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        title: Text(
          "Riwayat Peminjaman",
          style: AppTextStyles.primaryText.copyWith(color: Warna.putih),
        ),
        centerTitle: true,
        backgroundColor: Warna.hitamBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Warna.putih),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: riwayatList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final data = riwayatList[index];
          return InkWell(
            onTap: () {
              // Get.toNamed(Routes.detailRiwayatPeminjam);
              // Using Navigator for now as Routes might not be fully propagated in GetX context during hot reload/testing without full restart,
              // but user requested file structure implies GetX. Sticking to GetX pattern as per routes.
              Navigator.of(context).pushNamed('/detail-riwayat-peminjam');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Warna.putih,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "No: ${data['no']}",
                        style: AppTextStyles.namaBarangText,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(data['status']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          data['status'],
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tgl Peminjaman",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        data['tglPeminjaman'],
                        style: AppTextStyles.stokText.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tgl Kembali",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        data['tglKembali'],
                        style: AppTextStyles.stokText.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Warna.ungu;
    }
  }
}
