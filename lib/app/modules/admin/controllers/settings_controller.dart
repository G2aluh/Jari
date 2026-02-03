import 'package:flutter/material.dart';
import 'package:jari/app/modules/admin/models/aturan_denda_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Rx variable untuk menampung aturan denda
  final Rx<AturanDenda?> aturanDendaHarian = Rx<AturanDenda?>(null);

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    // Listen to realtime changes for 'keterlambatan' rule
    aturanDendaHarian.bindStream(
      _supabase
          .from('aturan_denda')
          .stream(primaryKey: ['id'])
          .eq('jenis', 'keterlambatan')
          .map((event) {
            if (event.isNotEmpty) {
              return AturanDenda.fromJson(event.first);
            }
            return null;
          }),
    );
  }

  /// Update nilai denda
  Future<bool> updateDenda(num nilaiBaru) async {
    try {
      isLoading.value = true;

      // Simpan nilai lama untuk log
      final nilaiLama = aturanDendaHarian.value?.nilaiDenda ?? 0;

      if (aturanDendaHarian.value != null) {
        // Update existing row
        await _supabase
            .from('aturan_denda')
            .update({'nilai_denda': nilaiBaru})
            .eq('id', aturanDendaHarian.value!.id);

        // Refresh local data
        aturanDendaHarian.value = AturanDenda(
          id: aturanDendaHarian.value!.id,
          jenis: aturanDendaHarian.value!.jenis,
          nilaiDenda: nilaiBaru,
          aktif: aturanDendaHarian.value!.aktif,
          keterangan: aturanDendaHarian.value!.keterangan,
        );

        // Log aktivitas update denda
        await _logUpdateDenda(nilaiLama, nilaiBaru);
      } else {
        // Create new if not exists
        final res = await _supabase.from('aturan_denda').insert({
          'jenis': 'keterlambatan',
          'nilai_denda': nilaiBaru,
          'keterangan': 'Denda keterlambatan per hari',
          'aktif': true,
        }).select();

        if ((res as List).isNotEmpty) {
          aturanDendaHarian.value = AturanDenda.fromJson(res.first);

          // Log aktivitas pembuatan denda baru
          await _logUpdateDenda(0, nilaiBaru, isCreate: true);
        }
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan pengaturan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Log aktivitas update nominal denda ke Supabase
  Future<void> _logUpdateDenda(
    num nilaiLama,
    num nilaiBaru, {
    bool isCreate = false,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;

      // Format rupiah
      String formatRupiah(num nilai) {
        return 'Rp ${nilai.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
      }

      String aktivitas;
      if (isCreate) {
        aktivitas =
            'Membuat pengaturan denda keterlambatan: ${formatRupiah(nilaiBaru)}/hari';
      } else {
        aktivitas =
            'Mengubah nominal denda dari ${formatRupiah(nilaiLama)} menjadi ${formatRupiah(nilaiBaru)}/hari';
      }

      await _supabase.from('log_aktivitas').insert({
        'pengguna_id': currentUser?.id,
        'aktivitas': aktivitas,
        'dibuat_pada': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Jangan gagalkan operasi utama jika log gagal
      print('Gagal mencatat log aktivitas: $e');
    }
  }
}
