import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jari/app/core/services/report_pdf_service.dart';

class ReportGenerationController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =====================
  // STATE UI
  // =====================
  final selectedType = 'harian'.obs; // harian | mingguan | bulanan
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  final isGenerating = false.obs;
  final previewCount = 0.obs;

  // =====================
  // PRESET OTOMATIS
  // =====================
  void applyPreset() {
    final now = DateTime.now();

    if (selectedType.value == 'harian') {
      startDate.value = now;
      endDate.value = null;
    }

    if (selectedType.value == 'mingguan') {
      final monday = now.subtract(Duration(days: now.weekday - 1));
      startDate.value = monday;
      endDate.value = monday.add(const Duration(days: 6));
    }

    if (selectedType.value == 'bulanan') {
      startDate.value = DateTime(now.year, now.month, 1);
      endDate.value = DateTime(now.year, now.month + 1, 0);
    }
  }

  // =====================
  // PREVIEW JUMLAH DATA
  // =====================
  Future<void> previewDataCount() async {
    if (startDate.value == null) return;
    if (selectedType.value != 'harian' && endDate.value == null) return;

    final start = startDate.value!;
    final end = selectedType.value == 'harian'
        ? start.add(const Duration(days: 1))
        : endDate.value!.add(const Duration(days: 1));

    final res = await _supabase
        .from('peminjaman')
        .select('id')
        .gte('tanggal_pinjam', _toDate(start))
        .lt('tanggal_pinjam', _toDate(end));

    previewCount.value = res is List ? res.length : 0;
  }

  // =====================
  // GENERATE REPORT
  // =====================
  Future<void> generateReport() async {
    try {
      if (startDate.value == null) {
        throw Exception('Tanggal awal belum dipilih');
      }

      if (selectedType.value != 'harian' &&
          (endDate.value == null ||
              endDate.value!.isBefore(startDate.value!))) {
        throw Exception('Tanggal akhir tidak valid');
      }

      isGenerating.value = true;

      final start = startDate.value!;
      final end = selectedType.value == 'harian'
          ? start.add(const Duration(days: 1))
          : endDate.value!.add(const Duration(days: 1));

      final res = await _supabase
          .from('peminjaman')
          .select('''
            tanggal_pinjam,
            status,
            pengguna:peminjam_id ( nama ),
            detail_peminjaman ( alat ( nama_alat ) )
          ''')
          .gte('tanggal_pinjam', _toDate(start))
          .lt('tanggal_pinjam', _toDate(end));

      if (res is! List || res.isEmpty) {
        throw Exception('Tidak ada data pada periode ini');
      }

      final List<Map<String, dynamic>> data = [];

      for (final item in res) {
        final peminjam = item['pengguna'];
        final details = item['detail_peminjaman'] as List?;

        if (peminjam == null || details == null) continue;

        for (final d in details) {
          final alat = d['alat'];
          if (alat == null) continue;

          data.add({
            'alat': alat['nama_alat'],
            'peminjam': peminjam['nama'],
            'tanggal': item['tanggal_pinjam'],
            'status': item['status'],
          });
        }
      }

      await ReportPdfService.generate(
        title: 'Laporan ${selectedType.value.toUpperCase()}',
        period: _formatPeriod(),
        data: data,
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGenerating.value = false;
    }
  }

  // =====================
  // HELPERS
  // =====================
  String _formatPeriod() {
    if (selectedType.value == 'harian') {
      return 'Tanggal ${_fmt(startDate.value!)}';
    }
    return '${_fmt(startDate.value!)} - ${_fmt(endDate.value!)}';
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  String _toDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
