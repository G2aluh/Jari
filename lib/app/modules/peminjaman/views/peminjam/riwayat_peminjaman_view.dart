import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class RiwayatPeminjamanView extends StatefulWidget {
  const RiwayatPeminjamanView({super.key});

  @override
  State<RiwayatPeminjamanView> createState() => _RiwayatPeminjamanViewState();
}

class _RiwayatPeminjamanViewState extends State<RiwayatPeminjamanView> {
  final controller = Get.find<PeminjamDashboardController>();

  @override
  void initState() {
    super.initState();
    controller.fetchLoanHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: ActionChip(
          label: Text("Riwayat Peminjaman"),
          labelStyle: TextStyle(color: Warna.putih),
          avatar: Icon(IconlyBold.timeCircle, color: Warna.putih),
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Obx(() {
          if (controller.isLoadingHistory.value) {
            return Center(child: CircularProgressIndicator(color: Warna.ungu));
          }

          if (controller.errorHistory.value.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorHistory.value,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final riwayatList = controller.loanHistory;

          return ListView(
            children: [
              SizedBox(height: 16),
              // Search Bar
              TextField(
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  hintText: 'Cari riwayat...',
                  hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
                  prefixIcon: Icon(
                    IconlyLight.search,
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
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 24),

              // Empty State
              if (riwayatList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyLight.document,
                          size: 80,
                          color: Warna.abuAbu.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Belum ada riwayat peminjaman",
                          style: TextStyle(color: Warna.abuAbu),
                        ),
                      ],
                    ),
                  ),
                )
              else
                // List Items
                ...riwayatList.map((loan) => _buildRiwayatCard(loan)).toList(),
              SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRiwayatCard(Peminjaman loan) {
    final status = controller.getStatusDisplayText(loan);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "No: ${loan.kodePeminjaman ?? loan.id.substring(0, 8)}",
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getTextColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1, color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tgl Peminjaman",
                style: TextStyle(color: Warna.putih.withOpacity(0.7)),
              ),
              Text(
                loan.tanggalPinjamFormatted,
                style: AppTextStyles.stokText.copyWith(color: Warna.putih),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tgl Kembali",
                style: TextStyle(color: Warna.putih.withOpacity(0.7)),
              ),
              Text(
                loan.tanggalDikembalikanFormatted,
                style: AppTextStyles.stokText.copyWith(color: Warna.putih),
              ),
            ],
          ),
          // Show fine if exists
          if (loan.totalDenda > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Denda",
                  style: TextStyle(color: Colors.red.withOpacity(0.8)),
                ),
                Text(
                  loan.totalDendaFormatted,
                  style: AppTextStyles.stokText.copyWith(color: Colors.red),
                ),
              ],
            ),
          ],
          // Show rejection reason if exists
          if (loan.catatanPenolakan != null &&
              loan.catatanPenolakan!.isNotEmpty) ...[
            const SizedBox(height: 8),
          
          ],
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    backgroundColor: Warna.abuAbu.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/detail-riwayat-peminjam', arguments: loan);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconlyBold.document, color: Warna.putih, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Lihat Detail",
                        style: TextStyle(color: Warna.putih),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange.withOpacity(0.2);
      case 'Selesai':
        return Colors.green.withOpacity(0.2);
      case 'Ditolak':
        return Colors.redAccent.withOpacity(0.2);
      case 'Disetujui':
        return Colors.greenAccent.withOpacity(0.2);
      case 'Terlambat':
        return Colors.red.withOpacity(0.2);
      case 'Batal':
        return Colors.grey.withOpacity(0.2);
      default:
        return Warna.ungu.withOpacity(0.2);
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      case 'Ditolak':
        return Colors.redAccent;
      case 'Disetujui':
        return Colors.greenAccent;
      case 'Terlambat':
        return Colors.red;
      case 'Batal':
        return Colors.grey;
      default:
        return Warna.ungu;
    }
  }
}
