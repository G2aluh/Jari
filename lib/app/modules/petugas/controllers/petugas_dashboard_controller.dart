import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';

class PetugasDashboardController extends GetxController {
  // ===============================
  // SUPABASE
  // ===============================
  final SupabaseClient supabase = Supabase.instance.client;

  // ===============================
  // STATE - LOAN VERIFICATION
  // ===============================
  final RxList<Peminjaman> pendingLoans = <Peminjaman>[].obs;
  final RxBool isLoadingLoans = false.obs;
  final RxString errorLoans = ''.obs;

  // ===============================
  // STATE - RETURN MONITORING
  // ===============================
  final RxList<Peminjaman> activeLoans =
      <Peminjaman>[].obs; // status = disetujui
  final RxList<Pengembalian> pendingReturns = <Pengembalian>[].obs;
  final RxBool isLoadingReturns = false.obs;
  final RxString errorReturns = ''.obs;

  // ===============================
  // REALTIME SUBSCRIPTIONS
  // ===============================
  RealtimeChannel? _peminjamanChannel;
  RealtimeChannel? _pengembalianChannel;

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    fetchPendingLoans();
    fetchActiveLoans();
    fetchPendingReturns();
    _setupRealtimeSubscriptions();
  }

  @override
  void onClose() {
    _peminjamanChannel?.unsubscribe();
    _pengembalianChannel?.unsubscribe();
    super.onClose();
  }

  // ===============================
  // REALTIME SETUP
  // ===============================
  void _setupRealtimeSubscriptions() {
    _peminjamanChannel = supabase
        .channel('public:peminjaman')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'peminjaman',
          callback: (payload) {
            fetchPendingLoans();
            fetchActiveLoans();
          },
        )
        .subscribe();

    _pengembalianChannel = supabase
        .channel('public:pengembalian')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pengembalian',
          callback: (payload) {
            fetchPendingReturns();
            fetchActiveLoans();
          },
        )
        .subscribe();
  }

  // ===============================
  // LOAN VERIFICATION - FETCH
  // ===============================
  Future<void> fetchPendingLoans() async {
    try {
      isLoadingLoans.value = true;
      errorLoans.value = '';

      final result = await supabase
          .from('peminjaman')
          .select('''
            *,
            peminjam:pengguna!peminjaman_peminjam_id_fkey(id, nama, email),
            detail_peminjaman(
              id,
              peminjaman_id,
              alat_id,
              jumlah,
              alat(id, kode_alat, nama_alat, alat_url)
            )
          ''')
          .eq('status', 'menunggu')
          .order('dibuat_pada', ascending: false);

      pendingLoans.assignAll(
        (result as List).map((e) => Peminjaman.fromJson(e)).toList(),
      );
    } catch (e) {
      errorLoans.value = e.toString();
    } finally {
      isLoadingLoans.value = false;
    }
  }

  // ===============================
  // LOAN VERIFICATION - APPROVE
  // ===============================
  Future<void> approveLoan(String peminjamanId) async {
    try {
      final petugasId = supabase.auth.currentUser?.id;

      // Update peminjaman status to disetujui
      await supabase
          .from('peminjaman')
          .update({
            'status': 'disetujui',
            'petugas_id': petugasId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      // Update stock (reduce stok_tersedia)
      final details = await supabase
          .from('detail_peminjaman')
          .select('alat_id, jumlah')
          .eq('peminjaman_id', peminjamanId);

      for (final detail in details) {
        await supabase.rpc(
          'decrement_stock',
          params: {
            'p_alat_id': detail['alat_id'],
            'p_jumlah': int.tryParse(detail['jumlah'].toString()) ?? 0,
          },
        );
      }

      Get.snackbar(
        'Berhasil',
        'Peminjaman berhasil disetujui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );

      fetchPendingLoans();
      fetchActiveLoans();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    }
  }

  // ===============================
  // LOAN VERIFICATION - REJECT
  // ===============================
  Future<void> rejectLoan(String peminjamanId, String alasanPenolakan) async {
    try {
      final petugasId = supabase.auth.currentUser?.id;

      await supabase
          .from('peminjaman')
          .update({
            'status': 'ditolak',
            'petugas_id': petugasId,
            'catatan_penolakan': alasanPenolakan,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      Get.snackbar(
        'Berhasil',
        'Peminjaman berhasil ditolak',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );

      fetchPendingLoans();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    }
  }

  // ===============================
  // RETURN MONITORING - FETCH ACTIVE LOANS
  // ===============================
  Future<void> fetchActiveLoans() async {
    try {
      isLoadingReturns.value = true;
      errorReturns.value = '';

      final result = await supabase
          .from('peminjaman')
          .select('''
            *,
            peminjam:pengguna!peminjaman_peminjam_id_fkey(id, nama, email),
            detail_peminjaman(
              id,
              peminjaman_id,
              alat_id,
              jumlah,
              alat(id, kode_alat, nama_alat, alat_url)
            ),
            pengembalian(id, peminjaman_id, status, tanggal_kembali, terlambat_hari, total_denda)
          ''')
          .eq('status', 'disetujui')
          .order('dibuat_pada', ascending: false);

      activeLoans.assignAll(
        (result as List).map((e) => Peminjaman.fromJson(e)).toList(),
      );
    } catch (e) {
      errorReturns.value = e.toString();
    } finally {
      isLoadingReturns.value = false;
    }
  }

  // ===============================
  // RETURN MONITORING - FETCH PENDING RETURNS
  // ===============================
  Future<void> fetchPendingReturns() async {
    try {
      final result = await supabase
          .from('pengembalian')
          .select('''
            *,
            peminjaman(
              *,
              peminjam:pengguna!peminjaman_peminjam_id_fkey(id, nama, email),
              detail_peminjaman(
                id,
                peminjaman_id,
                alat_id,
                jumlah,
                alat(id, kode_alat, nama_alat, alat_url)
              )
            )
          ''')
          .eq('status', 'menunggu')
          .order('dibuat_pada', ascending: false);

      pendingReturns.assignAll(
        (result as List).map((e) => Pengembalian.fromJson(e)).toList(),
      );
    } catch (e) {
      errorReturns.value = e.toString();
    }
  }

  // ===============================
  // RETURN MONITORING - CONFIRM RETURN
  // ===============================
  Future<void> confirmReturn(String pengembalianId, String peminjamanId) async {
    try {
      final petugasId = supabase.auth.currentUser?.id;

      // Update pengembalian status to selesai
      await supabase
          .from('pengembalian')
          .update({
            'status': 'selesai',
            'petugas_id': petugasId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', pengembalianId);

      // Update peminjaman status to selesai
      await supabase
          .from('peminjaman')
          .update({
            'status': 'selesai',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      // Restore stock
      final details = await supabase
          .from('detail_peminjaman')
          .select('alat_id, jumlah')
          .eq('peminjaman_id', peminjamanId);

      for (final detail in details) {
        await supabase.rpc(
          'increment_stock',
          params: {
            'p_alat_id': detail['alat_id'],
            'p_jumlah': int.tryParse(detail['jumlah'].toString()) ?? 0,
          },
        );
      }

      Get.snackbar(
        'Berhasil',
        'Pengembalian berhasil dikonfirmasi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );

      fetchPendingReturns();
      fetchActiveLoans();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    }
  }

  // ===============================
  // RETURN MONITORING - REJECT RETURN
  // ===============================
  Future<void> rejectReturn(
    String pengembalianId,
    String peminjamanId,
    String alasanPenolakan,
  ) async {
    try {
      // Delete the pengembalian record (so peminjam can resubmit)
      await supabase.from('pengembalian').delete().eq('id', pengembalianId);

      // Save rejection reason to peminjaman
      await supabase
          .from('peminjaman')
          .update({
            'catatan_penolakan': alasanPenolakan,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      Get.snackbar(
        'Berhasil',
        'Pengembalian ditolak',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );

      fetchPendingReturns();
      fetchActiveLoans();
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    }
  }

  // ===============================
  // HELPER - Get Pengembalian for a Peminjaman
  // ===============================
  Pengembalian? getPengembalianForPeminjaman(String peminjamanId) {
    return pendingReturns.firstWhereOrNull(
      (p) => p.peminjamanId == peminjamanId,
    );
  }

  // ===============================
  // HELPER - Check if loan has pending return
  // ===============================
  bool hasPendingReturn(String peminjamanId) {
    return pendingReturns.any((p) => p.peminjamanId == peminjamanId);
  }
}
