import 'package:benang_merah/app/core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ReturnEquipmentView extends StatelessWidget {
  const ReturnEquipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> returnList = [
      {
        'id': 'PJM-20260114-0001',
        'item': 'Mesin Jahit',
        'tglPeminjaman': '12/01/2026',
        'status': 'Dipinjam',
        'tglKembali': '15/01/2026',
      },
      {
        'id': 'PJM-20260114-0003',
        'item': 'Gerinda Tangan',
        'tglPeminjaman': '05/01/2026',
        'status': 'Terlambat',
        'tglKembali': '10/01/2026',
      },
      {
        'id': 'PJM-20260114-0004',
        'item': 'Obeng Set',
        'tglPeminjaman': '14/01/2026',
        'status': 'Dipinjam',
        'tglKembali': '17/01/2026',
      },
    ];

    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: Text('Pengembalian Alat', style: TextStyle(color: Warna.putih)),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => Get.back(),
          icon: Icon(IconlyLight.arrowLeft2),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    style: TextStyle(color: Warna.putih),
                    decoration: InputDecoration(
                      hintText: 'Cari pengembalian...',
                      hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                      prefixIcon: Icon(
                        IconlyLight.search,
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
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Late Item Alert
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
                  SizedBox(height: 24),

                  // List Items
                  if (returnList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 80,
                              color: Warna.abuAbu.withOpacity(0.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Tidak ada barang yang perlu dikembalikan",
                              style: TextStyle(color: Warna.abuAbu),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...returnList.map((data) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Warna.hitamTransparan,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Warna.ungu.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    color: Warna.ungu,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Only showing ID as requested
                                      Text(
                                        data['id'],
                                        style: TextStyle(
                                          color: Warna.putih,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                            const Divider(
                              height: 24,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tgl Peminjaman",
                                  style: TextStyle(
                                    color: Warna.putih.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  data['tglPeminjaman'],
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Batas Kembali",
                                  style: TextStyle(
                                    color: Warna.putih.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  data['tglKembali'],
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Warna.ungu,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  // Action to return item
                                  Get.snackbar(
                                    "Info",
                                    "Fitur pengembalian belum tersedia",
                                  );
                                },
                                child: Text(
                                  "Kembalikan Barang",
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dipinjam':
        return Colors.blue.withOpacity(0.2);
      case 'Terlambat':
        return Colors.red.withOpacity(0.2);
      default:
        return Warna.ungu.withOpacity(0.2);
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Dipinjam':
        return Colors.blue;
      case 'Terlambat':
        return Colors.red;
      default:
        return Warna.ungu;
    }
  }
}
