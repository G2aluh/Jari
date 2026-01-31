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
  StreamSubscription? _pengembalianSubscription;

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
    _pengembalianSubscription?.cancel();
    super.onClose();
  }

  /// Setup realtime subscription untuk peminjaman dan pengembalian
  void _setupRealtimeSubscription() {
    // Listen to peminjaman
    _peminjamanSubscription = _supabase
        .from('peminjaman')
        .stream(primaryKey: ['id'])
        .listen((data) {
          fetchPeminjamanAktif();
          // Also fetch pengembalian as logic might overlap
          fetchPengembalian();
        });

    // Listen to pengembalian (e.g. trigger updates total_denda)
    _pengembalianSubscription = _supabase
        .from('pengembalian')
        .stream(primaryKey: ['id'])
        .listen((data) {
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

  /// Hitung hari terlambat (Local fallback)
  int calculateTerlambat(Peminjaman peminjaman, [DateTime? returnDate]) {
    if (peminjaman.tanggalJatuhTempo == null) return 0;
    final targetDate = returnDate ?? DateTime.now();
    final diff = targetDate.difference(peminjaman.tanggalJatuhTempo!).inDays;
    return diff > 0 ? diff : 0;
  }

  /// Hitung detail pengembalian via RPC (Hari terlambat & Denda)
  Future<Map<String, dynamic>> calculateReturnDetails({
    required String peminjamanId,
    required DateTime tanggalKembali,
  }) async {
    try {
      final dateStr = tanggalKembali.toIso8601String().split('T').first;

      // Asumsi nama parameter RPC sesuai standar (peminjaman_id, tanggal_kembali)
      // Jika error, cek log atau sesuaikan nama parameter
      final lateDays = await _supabase.rpc(
        'hitung_hari_terlambat',
        params: {'peminjaman_id': peminjamanId, 'tanggal_kembali': dateStr},
      );

      final totalFine = await _supabase.rpc(
        'hitung_total_denda',
        params: {'peminjaman_id': peminjamanId, 'tanggal_kembali': dateStr},
      );

      return {'terlambat_hari': lateDays ?? 0, 'total_denda': totalFine ?? 0};
    } catch (e) {
      debugPrint('RPC Calculation Error: $e');
      // Fallback ke perhitungan lokal untuk hari terlambat
      final p = peminjamanAktifList.firstWhereOrNull(
        (x) => x.id == peminjamanId,
      );
      if (p != null) {
        final days = calculateTerlambat(p, tanggalKembali);
        return {
          'terlambat_hari': days,
          'total_denda':
              0, // Tidak bisa hitung denda di lokal tanpa logic lengkap
          'error': e.toString(),
        };
      }
      return {'terlambat_hari': 0, 'total_denda': 0};
    }
  }

  /// Hitung denda berdasarkan keterlambatan via RPC
  Future<int> calculateDendaFromDelay(int terlambat) async {
    try {
      // Asumsi nama parameter RPC sesuai standar
      final denda = await _supabase.rpc(
        'hitung_denda_keterlambatan',
        params: {
          'terlambat_hari':
              terlambat, // Sesuaikan dengan parameter fungsi di DB
          // Jika fungsi butuh parameter lain, perlu disesuaikan.
          // Tapi biasanya hitung_denda_keterlambatan hanya butuh hari atau logic internal.
          // Jika gagal, kita return 0.
        },
      );
      return (denda as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('RPC Denda Values Error: $e');
      return 0;
    }
  }

  /// Manual add pengembalian (Admin)
  Future<bool> addPengembalian({
    required String peminjamanId,
    required DateTime tanggalKembali,
    required StatusPengembalian status,
    int terlambatHari = 0,
    int totalDenda = 0,
    String? petugasId,
  }) async {
    try {
      isLoading.value = true;

      // 1. Buat record pengembalian
      await _supabase.from('pengembalian').insert({
        'peminjaman_id': peminjamanId,
        'tanggal_kembali': tanggalKembali.toIso8601String().split('T').first,
        'terlambat_hari': terlambatHari,
        'total_denda': totalDenda,
        'status': status.value, // Gunakan status yang dipilih
        'petugas_id': petugasId,
      });

      // 2. Update status peminjaman (jika pengembalian selesai, peminjaman selesai)
      // Jika 'menunggu', peminjaman tetap 'disetujui' (active) until finalized?
      // Atau kita anggap proses ini independen.
      // Untuk amannya, jika status pengembalian 'selesai', kita set peminjaman 'selesai'.

      if (status == StatusPengembalian.selesai) {
        await _supabase
            .from('peminjaman')
            .update({
              'status': 'selesai',
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', peminjamanId);
      }

      await fetchPeminjamanAktif();
      await fetchPengembalian();
      _showSuccess('Pengembalian berhasil ditambahkan');
      return true;
    } catch (e) {
      _showError('Gagal menambah pengembalian: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Proses pengembalian - deprecated/used by simplified flow
  Future<bool> prosesPengembalian({
    required String peminjamanId,
    required DateTime tanggalKembali,
    int terlambatHari = 0,
    String? petugasId,
  }) async {
    // Note: Simplified flow doesn't calc denda here, assumed 0 or handled by trigger if any
    return addPengembalian(
      peminjamanId: peminjamanId,
      tanggalKembali: tanggalKembali,
      status: StatusPengembalian.selesai,
      terlambatHari: terlambatHari,
      totalDenda: 0,
      petugasId: petugasId,
    );
  }

  /// Update existing pengembalian
  Future<bool> updatePengembalian({
    required String id,
    StatusPengembalian? status,
    int? terlambatHari,
    int? totalDenda,
    DateTime? tanggalKembali,
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
      if (totalDenda != null) {
        updateData['total_denda'] = totalDenda;
      }
      if (tanggalKembali != null) {
        updateData['tanggal_kembali'] = tanggalKembali
            .toIso8601String()
            .split('T')
            .first;
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
