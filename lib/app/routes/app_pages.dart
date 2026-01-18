import 'package:get/get.dart';

// Auth
import '../modules/auth/views/login_view.dart';
import '../modules/auth/bindings/auth_binding.dart';

// Peminjam
import '../modules/dashboard/peminjam/peminjam_dashboard_view.dart';
import '../modules/peminjaman/views/peminjam/riwayat_peminjaman_view.dart';
import '../modules/peminjaman/views/peminjam/dialog/detail_riwayat_peminjaman_view.dart';
import '../modules/peminjam/views/return_equipment/return_equipment_view.dart';

// Admin
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/admin/bindings/admin_dashboard_binding.dart';
import '../modules/admin/views/user_management/user_management_view.dart';
import '../modules/admin/views/equipment_management/equipment_management_view.dart';
import '../modules/admin/views/category_management/category_management_view.dart';
import '../modules/admin/views/activity_log/activity_log_view.dart';

// Petugas
import '../modules/petugas/views/petugas_dashboard_view.dart';
import '../modules/petugas/bindings/petugas_dashboard_binding.dart';
import '../modules/petugas/views/loan_verification/loan_verification_view.dart';
import '../modules/petugas/views/return_monitoring/return_monitoring_view.dart';
import '../modules/petugas/views/report_generation/report_generation_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // Authentication
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    // Peminjam Dashboard
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
    GetPage(
      name: Routes.returnEquipment,
      page: () => const ReturnEquipmentView(),
    ),

    // Admin Dashboard
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.userManagement,
      page: () => const UserManagementView(),
    ),
    GetPage(
      name: Routes.equipmentManagement,
      page: () => const EquipmentManagementView(),
    ),
    GetPage(
      name: Routes.categoryManagement,
      page: () => const CategoryManagementView(),
    ),
    GetPage(name: Routes.activityLog, page: () => const ActivityLogView()),

    // Petugas Dashboard
    GetPage(
      name: Routes.petugasDashboard,
      page: () => const PetugasDashboardView(),
      binding: PetugasDashboardBinding(),
    ),
    GetPage(
      name: Routes.loanVerification,
      page: () => const LoanVerificationView(),
    ),
    GetPage(
      name: Routes.returnMonitoring,
      page: () => const ReturnMonitoringView(),
    ),
    GetPage(
      name: Routes.reportGeneration,
      page: () => const ReportGenerationView(),
    ),
  ];
}
