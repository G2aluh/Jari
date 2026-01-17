import 'package:get/get.dart';
import '../modules/dashboard/peminjam/peminjam_dashboard_view.dart';
import '../modules/peminjaman/views/peminjam/riwayat_peminjaman_view.dart';
import '../modules/peminjaman/views/peminjam/dialog/detail_riwayat_peminjaman_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.peminjamDashboard,
      page: () => const PeminjamDashboardView(),
    ),
    GetPage(
      name: Routes.riwayatPeminjam,
      page: () => const RiwayatPeminjamanView(),
    ),
    GetPage(
      name: Routes.detailRiwayatPeminjam,
      page: () => const DetailRiwayatPeminjamanView(),
    ),
  ];
}
