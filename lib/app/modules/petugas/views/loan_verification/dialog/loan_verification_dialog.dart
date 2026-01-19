import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class KonfirmasiPeminjamanDialog extends StatelessWidget {
  const KonfirmasiPeminjamanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Konfirmasi Peminjaman",
                  style: AppTextStyles.primaryText.copyWith(
                    fontSize: 18,
                    color: Warna.putih,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Warna.putih),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Warna.abuAbu,
                  foregroundColor: Warna.putih,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _showDaftarAlatDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text("Daftar Alat"),
                        Icon(Icons.arrow_forward, color: Warna.putih),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildReadOnlyField("Peminjam", "Peminjam 1"),
            SizedBox(height: 12),
            _buildReadOnlyField("Tanggal Jatuh Tempo", "16 Jan 2026"),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Warna.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Warna.putih),
                      ),
                    ),
                    onPressed: () {
                      // Handle damage assessment selection
                      Navigator.pop(context); // Close dialog for now
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, color: Warna.putih),
                        SizedBox(width: 4),
                        Text("Cetak"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: Warna.ijo,
                      foregroundColor: Warna.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Handle damage assessment selection
                      Navigator.pop(context); // Close dialog for now
                    },
                    child: Text("Konfirmasi"),
                  ),
                ),
              ],
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
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Warna.abuAbu,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Warna.putih,
              fontSize: 14,
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
              Divider(color: Warna.putih.withOpacity(0.2)),
              _buildAlatItem("Benang", "5"),
              Divider(color: Warna.putih.withOpacity(0.2)),
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
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
