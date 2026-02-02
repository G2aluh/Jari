import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class DetailRiwayatPeminjamanView extends StatelessWidget {
  const DetailRiwayatPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the loan data from arguments
    final Peminjaman? loan = Get.arguments as Peminjaman?;

    if (loan == null) {
      return Scaffold(
        backgroundColor: Warna.hitamBackground,
        appBar: AppBar(
          backgroundColor: Warna.hitamBackground,
          foregroundColor: Warna.putih,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Warna.putih),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(
            "Data tidak ditemukan",
            style: TextStyle(color: Warna.putih),
          ),
        ),
      );
    }

    // Get pengembalian data if available
    final pengembalianList = loan.toJson()['pengembalian'] as List<dynamic>?;
    final hasPengembalian =
        pengembalianList != null && pengembalianList.isNotEmpty;
    final pengembalian = hasPengembalian ? pengembalianList.first : null;

    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: ActionChip(
          label: Text("Detail Peminjaman"),
          labelStyle: TextStyle(color: Warna.putih),
          avatar: Icon(IconlyBold.paper, color: Warna.putih),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: Warna.hitamTransparan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                  ),
                ),
                onPressed: () => _showDaftarAlatDialog(context, loan),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daftar Alat",
                      style: TextStyle(color: Warna.putih, fontSize: 14),
                    ),
                    Icon(Icons.arrow_forward, color: Warna.putih),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildReadOnlyField(
              "Kode Peminjaman",
              loan.kodePeminjaman ?? loan.id.substring(0, 8),
            ),
            SizedBox(height: 16),
            _buildReadOnlyField(
              "Tanggal Jatuh Tempo",
              loan.tanggalJatuhTempoFormatted,
            ),
            SizedBox(height: 16),
            _buildReadOnlyField(
              "Tanggal Kembali",
              loan.tanggalKembaliFormatted,
            ),
            SizedBox(height: 16),
            _buildReadOnlyField(
              "Denda",
              hasPengembalian
                  ? "Rp ${pengembalian['total_denda'] ?? 0}"
                  : "Rp 0",
            ),
            if (loan.catatanPenolakan != null &&
                loan.catatanPenolakan!.isNotEmpty) ...[
              SizedBox(height: 16),
              _buildReadOnlyField(
                "Catatan/Alasan Penolakan",
                loan.catatanPenolakan!,
                isWarning: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    String label,
    String value, {
    bool isWarning = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isWarning ? Colors.orange : Warna.putih,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Warna.hitamTransparan,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isWarning
                  ? Colors.orange.withOpacity(0.5)
                  : Warna.putih.withOpacity(0.2),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: isWarning ? Colors.orange : Warna.putih,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showDaftarAlatDialog(BuildContext context, Peminjaman loan) {
    final details = loan.detailPeminjaman ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Warna.hitamBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Warna.putih.withOpacity(0.2)),
          ),
          icon: Row(
            children: [
              Icon(Icons.info, color: Warna.putih, size: 20),
              SizedBox(width: 4),
              Text(
                "Daftar Alat Dipinjam",
                style: TextStyle(fontSize: 14, color: Warna.putih),
              ),
            ],
          ),
          content: details.isEmpty
              ? Text("Tidak ada alat", style: TextStyle(color: Warna.putih))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: details
                      .map(
                        (detail) => Column(
                          children: [
                            _buildAlatItem(
                              detail.namaAlat,
                              detail.jumlah.toString(),
                            ),
                            if (details.indexOf(detail) < details.length - 1)
                              Divider(color: Warna.putih.withOpacity(0.2)),
                          ],
                        ),
                      )
                      .toList(),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup", style: TextStyle(color: Warna.putih)),
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
          Text(name, style: TextStyle(fontSize: 16, color: Warna.putih)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Warna.putih.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "x$qty",
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
