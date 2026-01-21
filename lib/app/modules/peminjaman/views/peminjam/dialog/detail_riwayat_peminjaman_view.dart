import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class DetailRiwayatPeminjamanView extends StatelessWidget {
  const DetailRiwayatPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  backgroundColor: Warna.abuAbu,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showDaftarAlatDialog(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daftar Alat",
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Warna.putih,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildReadOnlyField("Keterangan", "Peminjaman untuk kegiatan A"),
            SizedBox(height: 16),
            _buildReadOnlyField("Tanggal Jatuh Tempo", "15/01/2026"),
            SizedBox(height: 16),
            _buildReadOnlyField("Tanggal Kembali", "-"),
            SizedBox(height: 16),
            _buildReadOnlyField("Denda", "Rp 0"),
            SizedBox(height: 32),
            _buildAjukanPengembalianButton(),
            
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Warna.putih, fontSize: 14)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Warna.abuAbu,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Warna.putih,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  //Ajukan pengembalian button
  Widget _buildAjukanPengembalianButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.all(16),
              backgroundColor: Warna.ungu,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: Warna.putih, size: 20),
                SizedBox(width: 8),
                Text(
                  "Ajukan Pengembalian",
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
          backgroundColor: Warna.abuAbu,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Row(
            children: [
              Icon(Icons.info, color: Warna.putih, size: 20),
              SizedBox(width: 4),
              Text("Daftar Alat Dipinjam", style: TextStyle(fontSize: 14, color: Warna.putih)),
            ],
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
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold ),
            ),
          ),
        ],
      ),
    );
  }
}
