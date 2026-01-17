import 'package:get/get.dart';
import '../modules/dashboard/peminjam/peminjam_dashboard_view.dart';
import '../modules/dashboard/admin/admin_dashboard_view.dart';
import '../modules/dashboard/petugas/petugas_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.peminjamDashboard,
      page: () => const PeminjamDashboardView(),
    ),
  ];
}
