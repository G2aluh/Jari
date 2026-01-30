import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Observable list of peminjaman
  final RxList<Peminjaman> peminjamanList = <Peminjaman>[].obs;
  final RxList<Peminjaman> filteredPeminjamanList = <Peminjaman>[].obs;

  // List of peminjam (untuk dropdown)
  final RxList<Pengguna> peminjamList = <Pengguna>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPeminjaman();
    fetchPeminjamList();
  }

  /// Fetch all peminjaman from Supabase with relations
  Future<void> fetchPeminjaman() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('peminjaman')
          .select('''
            *,
            peminjam:peminjam_id(id, nama, email, role),
            petugas:petugas_id(id, nama, email, role)
          ''')
          .order('dibuat_pada', ascending: false);

      peminjamanList.value = (response as List)
          .map((json) => Peminjaman.fromJson(json))
          .toList();

      _applySearch();
    } catch (e) {
      _showError('Gagal memuat data peminjaman: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch list of peminjam for dropdown
  Future<void> fetchPeminjamList() async {
    try {
      final response = await _supabase
          .from('pengguna')
          .select()
          .eq('role', 'peminjam')
          .eq('aktif', true)
          .order('nama');

      peminjamList.value = (response as List)
          .map((json) => Pengguna.fromJson(json))
          .toList();
    } catch (e) {
      // Silent fail - this is optional data
    }
  }

  /// Search peminjaman by kode or nama peminjam
  void searchPeminjaman(String query) {
    searchQuery.value = query;
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredPeminjamanList.value = peminjamanList.toList();
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredPeminjamanList.value = peminjamanList
          .where(
            (p) =>
                (p.kodePeminjaman?.toLowerCase().contains(query) ?? false) ||
                p.namaPeminjam.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  /// Add new peminjaman
  /// kode_peminjaman di-generate otomatis oleh trigger Supabase
  Future<bool> addPeminjaman({
    required String peminjamId,
    required DateTime tanggalPinjam,
    required DateTime tanggalJatuhTempo,
  }) async {
    try {
      isLoading.value = true;

      // kode_peminjaman tidak perlu dikirim,
      // akan di-generate oleh trigger 'generate_kode_peminjaman' di Supabase
      await _supabase.from('peminjaman').insert({
        'peminjam_id': peminjamId,
        'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T').first,
        'tanggal_jatuh_tempo': tanggalJatuhTempo
            .toIso8601String()
            .split('T')
            .first,
        'status': 'menunggu',
        'total_denda': 0,
      });

      await fetchPeminjaman();
      _showSuccess('Peminjaman berhasil ditambahkan');
      return true;
    } catch (e) {
      _showError('Gagal menambah peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing peminjaman
  Future<bool> updatePeminjaman({
    required String id,
    StatusPeminjaman? status,
    DateTime? tanggalJatuhTempo,
    String? catatanPenolakan,
    double? totalDenda,
    String? petugasId,
  }) async {
    try {
      isLoading.value = true;

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (status != null) {
        updateData['status'] = status.value;
      }
      if (tanggalJatuhTempo != null) {
        updateData['tanggal_jatuh_tempo'] = tanggalJatuhTempo
            .toIso8601String()
            .split('T')
            .first;
      }
      if (catatanPenolakan != null) {
        updateData['catatan_penolakan'] = catatanPenolakan;
      }
      if (totalDenda != null) {
        updateData['total_denda'] = totalDenda;
      }
      if (petugasId != null) {
        updateData['petugas_id'] = petugasId;
      }

      await _supabase.from('peminjaman').update(updateData).eq('id', id);

      await fetchPeminjaman();
      _showSuccess('Peminjaman berhasil diperbarui');
      return true;
    } catch (e) {
      _showError('Gagal memperbarui peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete peminjaman
  Future<bool> deletePeminjaman(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('peminjaman').delete().eq('id', id);

      await fetchPeminjaman();
      _showSuccess('Peminjaman berhasil dihapus');
      return true;
    } catch (e) {
      _showError('Gagal menghapus peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
    );
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
