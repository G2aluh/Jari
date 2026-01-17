import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class DetailRiwayatPeminjamanView extends StatelessWidget {
  const DetailRiwayatPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        title: Text(
          "Detail Peminjaman",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReadOnlyField("Keterangan", "Peminjaman untuk kegiatan A"),
            SizedBox(height: 16),
            _buildReadOnlyField("Tanggal Jatuh Tempo", "15/01/2026"),
            SizedBox(height: 16),
            _buildReadOnlyField("Tanggal Kembali", "13/01/2026"),
            SizedBox(height: 16),
            _buildReadOnlyField("Denda", "Rp 0"),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Warna.ungu,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showDaftarAlatDialog(context),
                child: Text(
                  "Daftar Alat",
                  style: TextStyle(
                    color: Warna.putih,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Warna.putih,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showDaftarAlatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Daftar Alat Dipinjam",
            style: AppTextStyles.namaBarangText.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAlatItem("Mesin Jahit", "1"),
              Divider(),
              _buildAlatItem("Benang", "5"),
              Divider(),
              _buildAlatItem("Gunting", "2"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup", style: TextStyle(color: Warna.ungu)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlatItem(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Warna.ungu.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "x$qty",
              style: TextStyle(color: Warna.ungu, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
