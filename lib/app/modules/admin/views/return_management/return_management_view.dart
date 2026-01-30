import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnManagementView extends StatelessWidget {
  ReturnManagementView({super.key});

  final PengembalianController controller = Get.put(PengembalianController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        children: [
          // Search Input
          TextField(
            onChanged: controller.searchPengembalian,
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // List - Menampilkan peminjaman yang perlu dikembalikan
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Warna.ungu),
                );
              }

              if (controller.filteredPeminjamanList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.green.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada peminjaman yang perlu dikembalikan',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredPeminjamanList.length,
                itemBuilder: (context, index) {
                  final peminjaman = controller.filteredPeminjamanList[index];
                  return _PeminjamanReturnCard(
                    peminjaman: peminjaman,
                    controller: controller,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Card untuk menampilkan peminjaman aktif yang perlu dikembalikan
class _PeminjamanReturnCard extends StatelessWidget {
  final Peminjaman peminjaman;
  final PengembalianController controller;

  const _PeminjamanReturnCard({
    required this.peminjaman,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final terlambat = controller.calculateTerlambat(peminjaman);
    final isLate = terlambat > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isLate
              ? Colors.red.withOpacity(0.5)
              : Warna.putih.withOpacity(0.2),
        ),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLate
                      ? Colors.red.withOpacity(0.2)
                      : Warna.ungu.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment,
                  color: isLate ? Colors.red : Warna.ungu,
                  size: 24,
                ),
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
                    const SizedBox(height: 4),
                    Text(
                      peminjaman.namaPeminjam,
                      style: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLate)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Terlambat $terlambat hari',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Warna.abuAbu.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Tanggal Pinjam',
                    peminjaman.tanggalPinjamFormatted,
                    Icons.calendar_today,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Warna.putih.withOpacity(0.2),
                ),
                Expanded(
                  child: _infoItem(
                    'Jatuh Tempo',
                    peminjaman.tanggalJatuhTempoFormatted,
                    Icons.event,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showProsesPengembalianDialog(context),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Proses Pengembalian',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLate ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Warna.putih.withOpacity(0.5), size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Warna.putih.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Warna.putih,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showProsesPengembalianDialog(BuildContext context) {
    final terlambat = controller.calculateTerlambat(peminjaman);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Warna.hitamBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Warna.putih.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_return,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Konfirmasi Pengembalian',
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Warna.abuAbu.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _dialogInfoRow('Kode', peminjaman.kodePeminjaman ?? '-'),
                    _dialogInfoRow('Peminjam', peminjaman.namaPeminjam),
                    _dialogInfoRow(
                      'Tanggal Kembali',
                      _formatDate(DateTime.now()),
                    ),
                    if (terlambat > 0)
                      _dialogInfoRow(
                        'Keterlambatan',
                        '$terlambat hari',
                        isWarning: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Warna.putih),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await controller.prosesPengembalian(
                          peminjamanId: peminjaman.id,
                          tanggalKembali: DateTime.now(),
                          terlambatHari: terlambat,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogInfoRow(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Warna.putih.withOpacity(0.6), fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? Colors.red : Warna.putih,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
