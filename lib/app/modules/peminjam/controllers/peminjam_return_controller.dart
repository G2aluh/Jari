import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';

class PeminjamReturnController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // ===============================
  // STATE
  // ===============================
  final RxList<Peminjaman> activeLoansForReturn = <Peminjaman>[].obs;
  final RxList<Peminjaman> filteredActiveLoansForReturn = <Peminjaman>[].obs;
  final TextEditingController searchReturnController = TextEditingController();
  final RxBool isLoadingReturns = false.obs;
  final RxString errorReturns = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveLoansForReturn();
    searchReturnController.addListener(_filterReturn);
  }

  @override
  void onClose() {
    searchReturnController.dispose();
    super.onClose();
  }

  // ===============================
  // LOGIC
  // ===============================
  Future<void> fetchActiveLoansForReturn() async {
    try {
      isLoadingReturns.value = true;
      errorReturns.value = '';

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

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
          .eq('peminjam_id', userId)
          .eq('status', 'disetujui')
          .order('dibuat_pada', ascending: false);

      final loans = (result as List)
          .map((e) => Peminjaman.fromJson(e))
          .toList();
      activeLoansForReturn.assignAll(loans);
      filteredActiveLoansForReturn.assignAll(loans);
    } catch (e) {
      errorReturns.value = e.toString();
    } finally {
      isLoadingReturns.value = false;
    }
  }

  void _filterReturn() {
    final search = searchReturnController.text.trim().toLowerCase();
    if (search.isEmpty) {
      filteredActiveLoansForReturn.assignAll(activeLoansForReturn);
    } else {
      filteredActiveLoansForReturn.assignAll(
        activeLoansForReturn.where((loan) {
          final kode = (loan.kodePeminjaman ?? '').toLowerCase();
          final id = loan.id.toLowerCase();
          final items =
              loan.detailPeminjaman
                  ?.map((d) => d.namaAlat.toLowerCase())
                  .join(' ') ??
              '';
          return kode.contains(search) ||
              id.contains(search) ||
              items.contains(search);
        }).toList(),
      );
    }
  }

  Future<void> submitReturnRequest(String peminjamanId) async {
    try {
      // Check if return already exists
      final existing = await supabase
          .from('pengembalian')
          .select('id')
          .eq('peminjaman_id', peminjamanId)
          .maybeSingle();

      if (existing != null) {
        Get.snackbar(
          'Info',
          'Pengajuan pengembalian sudah ada',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        );
        return;
      }

      // Get peminjaman details for late calculation
      final peminjaman = await supabase
          .from('peminjaman')
          .select('tanggal_jatuh_tempo')
          .eq('id', peminjamanId)
          .single();

      final tanggalJatuhTempo = DateTime.parse(
        peminjaman['tanggal_jatuh_tempo'],
      );
      final today = DateTime.now();
      final lateDays = today.difference(tanggalJatuhTempo).inDays;
      final terlambatHari = lateDays > 0 ? lateDays : 0;

      // Calculate total denda (get rate from aturan_denda)
      int totalDenda = 0;
      if (terlambatHari > 0) {
        final dendaRule = await supabase
            .from('aturan_denda')
            .select('nilai_denda')
            .eq('jenis', 'keterlambatan')
            .eq('aktif', true)
            .maybeSingle();

        if (dendaRule != null) {
          final nilaiDenda =
              int.tryParse(dendaRule['nilai_denda'].toString()) ?? 0;
          totalDenda = terlambatHari * nilaiDenda;
        }
      }

      // Create pengembalian record
      await supabase.from('pengembalian').insert({
        'peminjaman_id': peminjamanId,
        'tanggal_kembali': DateTime.now().toIso8601String(),
        'terlambat_hari': terlambatHari,
        'total_denda': totalDenda,
        'status': 'menunggu',
      });

      // Clear rejection reason if any
      await supabase
          .from('peminjaman')
          .update({
            'catatan_penolakan': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', peminjamanId);

      Get.snackbar(
        'Berhasil',
        'Pengajuan pengembalian berhasil dikirim',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );

      fetchActiveLoansForReturn();
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

  int get lateItemsCount {
    final today = DateTime.now();
    return activeLoansForReturn.where((loan) {
      if (loan.tanggalJatuhTempo == null) return false;
      return today.isAfter(loan.tanggalJatuhTempo!);
    }).length;
  }

  bool isLoanLate(Peminjaman loan) {
    if (loan.tanggalJatuhTempo == null) return false;
    return DateTime.now().isAfter(loan.tanggalJatuhTempo!);
  }

  Future<Map<String, dynamic>?> getPengembalianStatus(
    String peminjamanId,
  ) async {
    try {
      final result = await supabase
          .from('pengembalian')
          .select('id, status, tanggal_kembali')
          .eq('peminjaman_id', peminjamanId)
          .maybeSingle();
      return result;
    } catch (e) {
      return null;
    }
  }
}
