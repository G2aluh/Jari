import 'dart:async';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Peminjaman yang perlu dikembalikan (status disetujui)
  final RxList<Peminjaman> peminjamanAktifList = <Peminjaman>[].obs;
  final RxList<Peminjaman> filteredPeminjamanList = <Peminjaman>[].obs;

  // Pengembalian records
  final RxList<Pengembalian> pengembalianList = <Pengembalian>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Realtime subscription
  StreamSubscription? _peminjamanSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchPeminjamanAktif();
    fetchPengembalian();
    _setupRealtimeSubscription();
  }

  @override
  void onClose() {
    _peminjamanSubscription?.cancel();
    super.onClose();
  }

  /// Setup realtime subscription untuk peminjaman
  void _setupRealtimeSubscription() {
    _peminjamanSubscription = _supabase
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .listen((data) {
          // Refresh data ketika ada perubahan
          fetchPeminjamanAktif();
          fetchPengembalian();
        });
  }

  /// Fetch peminjaman yang sudah disetujui (aktif untuk dikembalikan)
  Future<void> fetchPeminjamanAktif() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('peminjaman')
          .select('''
            *,
            peminjam:peminjam_id(id, nama, email, role),
            petugas:petugas_id(id, nama, email, role)
          ''')
          .eq('status', 'disetujui')
          .order('tanggal_jatuh_tempo', ascending: true);

      peminjamanAktifList.value = (response as List)
          .map((json) => Peminjaman.fromJson(json))
          .toList();

      _applySearch();
    } catch (e) {
      _showError('Gagal memuat data peminjaman aktif: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all pengembalian records
  Future<void> fetchPengembalian() async {
    try {
      final response = await _supabase
          .from('pengembalian')
          .select('''
            *,
            peminjaman:peminjaman_id(
              id,
              kode_peminjaman,
              peminjam_id,
              tanggal_pinjam,
              tanggal_jatuh_tempo,
              status,
              peminjam:peminjam_id(id, nama, email)
            ),
            petugas:petugas_id(id, nama, email, role)
          ''')
          .order('dibuat_pada', ascending: false);

      pengembalianList.value = (response as List)
          .map((json) => Pengembalian.fromJson(json))
          .toList();
    } catch (e) {
      // Silent fail
    }
  }

  /// Search peminjaman by kode or nama peminjam
  void searchPengembalian(String query) {
    searchQuery.value = query;
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredPeminjamanList.value = peminjamanAktifList.toList();
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredPeminjamanList.value = peminjamanAktifList
          .where(
            (p) =>
                (p.kodePeminjaman?.toLowerCase().contains(query) ?? false) ||
                p.namaPeminjam.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  /// Hitung hari terlambat
  int calculateTerlambat(Peminjaman peminjaman) {
    if (peminjaman.tanggalJatuhTempo == null) return 0;
    final diff = DateTime.now()
        .difference(peminjaman.tanggalJatuhTempo!)
        .inDays;
    return diff > 0 ? diff : 0;
  }

  /// Proses pengembalian - buat record pengembalian dan update status peminjaman
  Future<bool> prosesPengembalian({
    required String peminjamanId,
    required DateTime tanggalKembali,
    int terlambatHari = 0,
    String? petugasId,
  }) async {
    try {
      isLoading.value = true;

      // 1. Buat record pengembalian
      await _supabase.from('pengembalian').insert({
        'peminjaman_id': peminjamanId,
        'tanggal_kembali': tanggalKembali.toIso8601String().split('T').first,
        'terlambat_hari': terlambatHari,
        'petugas_id': petugasId,
        'status': 'selesai',
      });

      // 2. Update status peminjaman menjadi 'selesai'
      await _supabase
          .from('peminjaman')
          .update({
            'status': 'selesai',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      await fetchPeminjamanAktif();
      await fetchPengembalian();
      _showSuccess('Pengembalian berhasil diproses');
      return true;
    } catch (e) {
      _showError('Gagal memproses pengembalian: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing pengembalian
  Future<bool> updatePengembalian({
    required String id,
    StatusPengembalian? status,
    int? terlambatHari,
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
      if (terlambatHari != null) {
        updateData['terlambat_hari'] = terlambatHari;
      }
      if (petugasId != null) {
        updateData['petugas_id'] = petugasId;
      }

      await _supabase.from('pengembalian').update(updateData).eq('id', id);

      await fetchPengembalian();
      _showSuccess('Pengembalian berhasil diperbarui');
      return true;
    } catch (e) {
      _showError('Gagal memperbarui pengembalian: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete pengembalian
  Future<bool> deletePengembalian(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('pengembalian').delete().eq('id', id);

      await fetchPengembalian();
      _showSuccess('Pengembalian berhasil dihapus');
      return true;
    } catch (e) {
      _showError('Gagal menghapus pengembalian: $e');
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
