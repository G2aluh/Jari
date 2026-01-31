import 'package:jari/app/modules/admin/models/log_aktivitas_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogAktivitasController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Observable list of logs
  final RxList<LogAktivitas> logList = <LogAktivitas>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  /// Fetch all logs from Supabase with user relation
  Future<void> fetchLogs() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('log_aktivitas')
          .select('''
            *,
            pengguna:pengguna_id(id, nama)
          ''')
          .order('dibuat_pada', ascending: false)
          .limit(30); // Limit to last 30 logs

      logList.value = (response as List)
          .map((json) => LogAktivitas.fromJson(json))
          .toList();
    } catch (e) {
      _showError('Gagal memuat log aktivitas: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh logs
  Future<void> refreshLogs() async {
    await fetchLogs();
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
    );
  }
}
