import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:jari/app/modules/petugas/controllers/petugas_dashboard_controller.dart';
import 'package:flutter/material.dart';

class RejectionReturnDialog extends StatefulWidget {
  final Pengembalian pengembalian;
  final Peminjaman loan;
  final PetugasDashboardController controller;

  const RejectionReturnDialog({
    super.key,
    required this.pengembalian,
    required this.loan,
    required this.controller,
  });

  @override
  State<RejectionReturnDialog> createState() => _RejectionReturnDialogState();
}

class _RejectionReturnDialogState extends State<RejectionReturnDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tolak Pengembalian",
            style: AppTextStyles.primaryText.copyWith(
              fontSize: 18,
              color: Warna.putih,
            ),
            textAlign: TextAlign.start,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Warna.putih),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   "Kode: ${widget.loan.kodePeminjaman ?? widget.loan.id.substring(0, 8)}",
          //   style: TextStyle(color: Warna.putih, fontWeight: FontWeight.w500),
          // ),
          // SizedBox(height: 8),
          // Text(
          //   "Peminjam: ${widget.loan.namaPeminjam}",
          //   style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          // ),
          SizedBox(height: 16),
          Text(
            "Masukkan alasan penolakan",
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            style: TextStyle(color: Warna.putih),
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Warna.abuAbu,
              hintText: "Contoh: Barang tidak sesuai",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final reason = _reasonController.text.trim();
                  if (reason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Masukkan alasan penolakan"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  widget.controller.rejectReturn(
                    widget.pengembalian.id,
                    widget.loan.id,
                    reason,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  "Tolak Pengembalian",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
