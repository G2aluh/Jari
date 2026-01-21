abstract class Routes {
  // Authentication
  static const login = '/login';

  // Peminjam Dashboard
  static const peminjamDashboard = '/peminjam-dashboard';
  static const riwayatPeminjam = '/riwayat-peminjam';
  static const detailRiwayatPeminjam = '/detail-riwayat-peminjam';
  static const returnEquipment = '/return-equipment';

  // Admin Dashboard
  static const adminDashboard = '/admin-dashboard';
  static const userManagement = '/user-management';
  static const equipmentManagement = '/equipment-management';
  static const categoryManagement = '/category-management';
  static const loanManagement = '/loan-management';
  static const returnManagement = '/return-management';
  static const activityLog = '/activity-log';

  // Petugas Dashboard
  static const petugasDashboard = '/petugas-dashboard';
  static const loanVerification = '/loan-verification';
  static const returnMonitoring = '/return-monitoring';
  static const reportGeneration = '/report-generation';
}
