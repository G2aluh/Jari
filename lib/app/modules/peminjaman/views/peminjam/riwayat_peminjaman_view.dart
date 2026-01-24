import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RiwayatPeminjamanView extends StatelessWidget {
  const RiwayatPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> riwayatList = [
      {
        'no': 'PJM-20260114-0001',
        'tglPeminjaman': '12/01/2026',
        'status': 'Dipinjam',
        'tglKembali': '-',
      },
      {
        'no': 'PJM-20260114-0002',
        'tglPeminjaman': '10/01/2026',
        'status': 'Selesai',
        'tglKembali': '13/01/2026',
      },
      {
        'no': 'PJM-20260114-0003',
        'tglPeminjaman': '05/01/2026',
        'status': 'Ditolak',
        'tglKembali': '-',
      },
      {
        'no': 'PJM-20260114-0004',
        'tglPeminjaman': '02/01/2026',
        'status': 'Menunggu',
        'tglKembali': '-',
      },
      {
        'no': 'PJM-20260114-0005',
        'tglPeminjaman': '02/01/2026',
        'status': 'Terlambat',
        'tglKembali': '-',
      },
      {
        'no': 'PJM-20260114-0006',
        'tglPeminjaman': '02/01/2026',
        'status': 'Terlambat',
        'tglKembali': '-',
      },
    ];

    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: ActionChip(
          label: Text("Riwayat Peminjaman"),
          labelStyle: TextStyle(color: Warna.putih),
          avatar: Icon(IconlyBold.timeCircle, color: Warna.putih),
          shape: StadiumBorder(),
          side: BorderSide(width: 0),
          backgroundColor: Warna.hitamTransparan,
          onPressed: () {},
        ),
        centerTitle: true,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Warna.putih),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {},
            icon: Icon(IconlyLight.search, color: Warna.putih),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(height: 16),
            // Search Bar
            TextField(
              style: TextStyle(color: Warna.putih),
              decoration: InputDecoration(
                hintText: 'Cari riwayat...',
                hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                prefixIcon: Icon(
                  IconlyLight.search,
                  color: Warna.putih.withOpacity(0.5),
                ),
                filled: true,
                fillColor: Warna.hitamTransparan,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Warna.ungu),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 24),

            // List Items
            ...riwayatList.map((data) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "No: ${data['no']}",
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              data['status'],
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['status'],
                            style: TextStyle(
                              color: _getTextColor(data['status']),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tgl Peminjaman",
                          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                        ),
                        Text(
                          data['tglPeminjaman'],
                          style: AppTextStyles.stokText.copyWith(
                            color: Warna.putih,
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
                          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                        ),
                        Text(
                          data['tglKembali'],
                          style: AppTextStyles.stokText.copyWith(
                            color: Warna.putih,
                          ),
                        ),
                      ],
                    ),
                    //LihatDetailButton
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              backgroundColor: Warna.abuAbu.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Warna.putih.withOpacity(0.2),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed('/detail-riwayat-peminjam');
                            },

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconlyBold.document,
                                  color: Warna.putih,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Lihat Detail",
                                  style: TextStyle(color: Warna.putih),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange.withOpacity(0.2);
      case 'Selesai':
        return Colors.green.withOpacity(0.2);
      case 'Ditolak':
        return Colors.redAccent.withOpacity(0.2);
      case 'Dipinjam':
        return Colors.greenAccent.withOpacity(0.2);
      case 'Terlambat':
        return Colors.red.withOpacity(0.2);
      default:
        return Warna.ungu.withOpacity(0.2);
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Ditolak':
        return Colors.redAccent;
      case 'Dipinjam':
        return Colors.greenAccent;
      case 'Terlambat':
        return Colors.red;
      default:
        return Warna.ungu;
    }
  }
}
