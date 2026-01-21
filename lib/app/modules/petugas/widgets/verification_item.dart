import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/petugas/views/loan_verification/dialog/loan_verification_dialog.dart';
import 'package:benang_merah/app/modules/petugas/widgets/rejection_dialog.dart';
import 'package:flutter/material.dart';

class VerificationItem extends StatelessWidget {
  final String name;
  final String date;
  final Color color;

  const VerificationItem({
    super.key,
    required this.name,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(color: Warna.putih)),
        subtitle: Text(
          'Tanggal: $date',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const KonfirmasiPeminjamanDialog(),
              ),
              icon: Icon(Icons.check, color: Colors.green),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const RejectionDialog(),
              ),
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
