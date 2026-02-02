import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:jari/app/modules/petugas/views/return_monitoring/dialog/rejection_return_dialog.dart';
import 'package:flutter/material.dart';

class DetailPengembalianDialog extends StatelessWidget {
  final Peminjaman loan;
  final Pengembalian? pengembalian;
  final PetugasDashboardController controller;

  const DetailPengembalianDialog({
    super.key,
    required this.loan,
    this.pengembalian,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final hasPendingReturn =
        pengembalian != null &&
        pengembalian!.status == StatusPengembalian.menunggu;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Pengembalian",
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
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () => _showDaftarAlatDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
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
            _buildReadOnlyField("Peminjam", loan.namaPeminjam),
            SizedBox(height: 12),
            _buildReadOnlyField(
              "Tanggal Jatuh Tempo",
              loan.tanggalJatuhTempoFormatted,
            ),
            SizedBox(height: 12),
            _buildReadOnlyField(
              "Tanggal Kembali",
              pengembalian?.tanggalKembaliFormatted ?? "-",
            ),
            SizedBox(height: 12),
            _buildReadOnlyField(
              "Total Denda",
              pengembalian != null ? "Rp ${pengembalian!.denda}" : "Rp 0",
            ),
            SizedBox(height: 16),
            // Konfirmasi dan Tolak buttons - only enabled when there is a pending return
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: hasPendingReturn
                          ? Colors.red
                          : Warna.abuAbu,
                      foregroundColor: Warna.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: hasPendingReturn
                        ? () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => RejectionReturnDialog(
                                pengembalian: pengembalian!,
                                loan: loan,
                                controller: controller,
                              ),
                            );
                          }
                        : null,
                    child: Text("Tolak"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: hasPendingReturn
                          ? Colors.green
                          : Warna.abuAbu,
                      foregroundColor: Warna.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: hasPendingReturn
                        ? () {
                            controller.confirmReturn(pengembalian!.id, loan.id);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text("Konfirmasi"),
                  ),
                ),
              ],
            ),
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
                      // Handle print
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print),
                        SizedBox(width: 8),
                        Text("Cetak"),
                      ],
                    ),
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
    final details = loan.detailPeminjaman ?? [];

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
