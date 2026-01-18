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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  style: TextStyle(color: Warna.putih),
                  decoration: InputDecoration(
                    hintText: "Cari riwayat peminjaman...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(IconlyLight.search, color: Colors.grey),
                    filled: true,
                    fillColor: Warna.abuAbu,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                SizedBox(height: 16),
                
                

                //Alert Barang Terlambat
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(IconlyBold.danger, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Peringatan Barang Terlambat",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Anda memiliki 2 barang yang belum dikembalikan melewati batas waktu.",
                              style: TextStyle(
                                color: Colors.red.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              itemCount: riwayatList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final data = riwayatList[index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
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
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontSize: 16,
                                ),
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
                                    color: _getTextColor(data['status']),
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
                                style: TextStyle(color: Warna.putih),
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
                                style: TextStyle(color: Warna.putih),
                              ),
                              Text(
                                data['tglKembali'],
                                style: AppTextStyles.stokText.copyWith(
                                  color: Warna.putih,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //LihatDetailButton
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Warna.abuAbu,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                
                  Navigator.of(context).pushNamed('/detail-riwayat-peminjam');
                            
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconlyBold.document, color: Warna.putih),
                                SizedBox(width: 8),
                                Text(
                                  "Lihat Detail & Pengembalian",
                                  style: TextStyle(color: Warna.putih),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
