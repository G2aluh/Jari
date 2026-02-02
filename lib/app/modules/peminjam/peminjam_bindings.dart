import 'package:get/get.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_history_controller.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_return_controller.dart';
import 'controllers/peminjam_dashboard_controller.dart';

class PeminjamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeminjamDashboardController>(
      () => PeminjamDashboardController(),
      fenix: true,
    );
    Get.lazyPut<PeminjamHistoryController>(
      () => PeminjamHistoryController(),
      fenix: true,
    );
    Get.lazyPut<PeminjamReturnController>(
      () => PeminjamReturnController(),
      fenix: true,
    );
  }
}
