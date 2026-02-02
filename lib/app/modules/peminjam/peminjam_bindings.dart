import 'package:get/get.dart';
import 'controllers/peminjam_dashboard_controller.dart';

class PeminjamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeminjamDashboardController>(
      () => PeminjamDashboardController(),
      fenix: true,
    );
  }
}
