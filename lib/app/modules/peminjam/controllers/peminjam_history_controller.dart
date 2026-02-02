import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';

class PeminjamHistoryController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // ===============================
  // STATE
  // ===============================
  final RxList<Peminjaman> loanHistory = <Peminjaman>[].obs;
  final RxList<Peminjaman> filteredLoanHistory = <Peminjaman>[].obs;
  final TextEditingController searchHistoryController = TextEditingController();
  final RxBool isLoadingHistory = false.obs;
  final RxString errorHistory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoanHistory();
    searchHistoryController.addListener(_filterHistory);
  }

  @override
  void onClose() {
    searchHistoryController.dispose();
    super.onClose();
  }

  // ===============================
  // LOGIC
  // ===============================
  Future<void> fetchLoanHistory() async {
    try {
      isLoadingHistory.value = true;
      errorHistory.value = '';

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
          .order('dibuat_pada', ascending: false);

      final loans = (result as List)
          .map((e) => Peminjaman.fromJson(e))
          .toList();
      loanHistory.assignAll(loans);
      filteredLoanHistory.assignAll(loans);
    } catch (e) {
      errorHistory.value = e.toString();
    } finally {
      isLoadingHistory.value = false;
    }
  }

  void _filterHistory() {
    final search = searchHistoryController.text.trim().toLowerCase();
    if (search.isEmpty) {
      filteredLoanHistory.assignAll(loanHistory);
    } else {
      filteredLoanHistory.assignAll(
        loanHistory.where((loan) {
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

  String getStatusDisplayText(Peminjaman loan) {
    switch (loan.status) {
      case StatusPeminjaman.menunggu:
        return 'Menunggu';
      case StatusPeminjaman.disetujui:
        if (loan.tanggalJatuhTempo != null &&
            DateTime.now().isAfter(loan.tanggalJatuhTempo!)) {
          return 'Terlambat';
        }
        return 'Disetujui';
      case StatusPeminjaman.ditolak:
        return 'Ditolak';
      case StatusPeminjaman.selesai:
        return 'Selesai';
      case StatusPeminjaman.terlambat:
        return 'Terlambat';
      case StatusPeminjaman.batal:
        return 'Batal';
      default:
        return 'Menunggu';
    }
  }
}
