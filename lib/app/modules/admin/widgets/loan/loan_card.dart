import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';

class LoanCard extends StatelessWidget {
  final Peminjaman peminjaman;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LoanCard({
    super.key,
    required this.peminjaman,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.ungu.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.assignment, color: Warna.ungu, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peminjaman.kodePeminjaman ?? 'No Code',
                    style: TextStyle(
                      color: Warna.putih,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    peminjaman.namaPeminjam,
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        peminjaman.tanggalPinjamFormatted,
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            peminjaman.status,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          peminjaman.status.displayName,
                          style: TextStyle(
                            color: _getStatusColor(peminjaman.status),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Warna.abuAbu,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Icon(Icons.edit, color: Warna.putih, size: 16),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Warna.abuAbu,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Icon(Icons.delete, color: Warna.putih, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(StatusPeminjaman status) {
    switch (status) {
      case StatusPeminjaman.menunggu:
        return Warna.kuning;
      case StatusPeminjaman.disetujui:
        return Colors.green;
      case StatusPeminjaman.ditolak:
        return Colors.red;
      case StatusPeminjaman.selesai:
        return Colors.blue;
    }
  }
}
