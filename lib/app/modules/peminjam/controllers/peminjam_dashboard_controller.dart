import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jari/app/modules/peminjam/views/dialog/pengajuan_peminjaman_dialog.dart';
import 'package:jari/app/modules/admin/models/peminjaman_model.dart';

class PeminjamDashboardController extends GetxController {
  // ===============================
  // SUPABASE
  // ===============================
  final SupabaseClient supabase = Supabase.instance.client;

  // ===============================
  // STATE DATA ALAT (DATABASE)
  // ===============================
  final RxList<Map<String, dynamic>> alatList = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingAlat = false.obs;
  final RxString errorAlat = ''.obs;
  final RxList<Map<String, dynamic>> kategoriListDb =
      <Map<String, dynamic>>[].obs;

  // ===============================
  // UI STATE (EXISTING)
  // ===============================
  var showBadge = false.obs;
  var isSearchActive = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString selectedKategoriId = ''.obs; // '' = semua
  final RxList<Map<String, dynamic>> allAlat = <Map<String, dynamic>>[].obs;

  String get selectedKategoriNama {
    if (selectedKategoriId.value.isEmpty) {
      return '';
    }

    final kategori = kategoriListDb.firstWhereOrNull(
      (k) => k['id'] == selectedKategoriId.value,
    );

    return kategori?['nama_kategori'] ?? '';
  }

  var rentedItems = <int>{}.obs;
  var rentedNewItem = <String>{}.obs;

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    fetchKategori();
    fetchAlat();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchKategori() async {
    final result = await supabase
        .from('kategori_alat')
        .select('id, nama_kategori, icon_code, icon_family, icon_package')
        .order('nama_kategori');

    kategoriListDb.assignAll(List<Map<String, dynamic>>.from(result));
  }

  Future<void> submitPeminjaman({
    required DateTime tanggalJatuhTempo,
    required Map<String, int> quantities,
    required String keterangan,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // =========================
      // 1. INSERT PEMINJAMAN
      // =========================
      final peminjaman = await supabase
          .from('peminjaman')
          .insert({
            'peminjam_id': userId,
            'tanggal_pinjam': DateTime.now().toIso8601String(),
            'tanggal_jatuh_tempo': tanggalJatuhTempo.toIso8601String(),
            'status': 'menunggu',
            'keterangan': keterangan.isNotEmpty ? keterangan : null,
          })
          .select()
          .single();

      final peminjamanId = peminjaman['id'];

      // =========================
      // 2. INSERT DETAIL PEMINJAMAN
      // =========================
      final List<Map<String, dynamic>> detailData = [];

      quantities.forEach((key, jumlah) {
        final index = int.parse(key.replaceAll('item_', ''));
        final alat = alatList[index];

        detailData.add({
          'peminjaman_id': peminjamanId,
          'alat_id': alat['id'],
          'jumlah': jumlah,
        });
      });

      await supabase.from('detail_peminjaman').insert(detailData);

      // =========================
      // 3. RESET STATE UI
      // =========================
      rentedItems.clear();
      showBadge.value = false;

      Get.snackbar(
        'Berhasil',
        'Peminjaman berhasil diajukan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      );
    }
  }

  // ===============================
  // FETCH DATA ALAT (STEP 1.1)
  // ===============================
  Future<void> fetchAlat() async {
    try {
      isLoadingAlat.value = true;
      errorAlat.value = '';

      final result = await supabase
          .from('alat')
          .select('''
          id,
          kode_alat,
          nama_alat,
          stok_tersedia,
          alat_url,
          kategori_id,
          dibuat_pada
        ''')
          .eq('aktif', true)
          .gt('stok_tersedia', 0)
          .order('dibuat_pada', ascending: false);

      allAlat.assignAll(List<Map<String, dynamic>>.from(result));

      // DEFAULT: tampil semua
      alatList.assignAll(allAlat);
    } catch (e) {
      errorAlat.value = e.toString();
    } finally {
      isLoadingAlat.value = false;
    }
  }

  // ===============================
  // SEARCH
  // ===============================
  void toggleSearch() {
    if (isSearchActive.value) {
      isSearchActive.value = false;
      searchController.clear();
    } else {
      isSearchActive.value = true;
    }
  }

  void filterByKategori(String kategoriId) {
    selectedKategoriId.value = kategoriId;

    if (kategoriId.isEmpty) {
      // tampilkan semua
      alatList.assignAll(allAlat);
    } else {
      // filter untuk EquipmentList SAJA
      alatList.assignAll(
        allAlat.where((alat) => alat['kategori_id'] == kategoriId).toList(),
      );
    }
  }

  // ===============================
  // RENT SELECTION
  // ===============================
  void toggleRent(int index) {
    if (rentedItems.contains(index)) {
      rentedItems.remove(index);
    } else {
      rentedItems.add(index);
    }
    _updateBadgeVisibility();
  }

  void toggleRentNewItem(String itemName) {
    if (rentedNewItem.contains(itemName)) {
      rentedNewItem.remove(itemName);
    } else {
      rentedNewItem.add(itemName);
    }
    _updateBadgeVisibility();
  }

  void _updateBadgeVisibility() {
    showBadge.value = rentedItems.isNotEmpty;
  }

  // ===============================
  // DIALOG PEMINJAMAN
  // ===============================
  void showRentalSelectionDialog(BuildContext context) {
    if (showBadge.value) {
      showDialog(
        context: context,
        builder: (context) {
          return RentalSelectionDialog(
            rentedItems: rentedItems,
            alatList: alatList.toList(),
            onSubmit: (tanggal, keterangan, quantities) {
              submitPeminjaman(
                tanggalJatuhTempo: tanggal,
                quantities: quantities,
                keterangan: keterangan,
              );
            },
          );
        },
      );
    } else {
      Get.snackbar(
        "Peringatan",
        "Pilih barang untuk dipinjam terlebih dahulu",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  // ===============================
  // DIALOG RIWAYAT & PENGEMBALIAN
  // ===============================
  void showHistorySelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSelectionItem(
              icon: Icons.history,
              title: "Riwayat Peminjaman",
              onTap: () {
                Get.back();
                Get.toNamed('/riwayat-peminjam');
              },
            ),
            const Divider(),
            _buildSelectionItem(
              icon: Icons.assignment_return,
              title: "Pengembalian Alat",
              onTap: () {
                Get.back();
                Get.toNamed('/return-equipment');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Map<String, dynamic>? get alatTerbaru {
    if (allAlat.isEmpty) return null;
    return allAlat.first; // selalu alat terbaru global
  }

  // ===============================
  // STATE - RETURN EQUIPMENT
  // ===============================
  final RxList<Peminjaman> activeLoansForReturn = <Peminjaman>[].obs;
  final RxBool isLoadingReturns = false.obs;
  final RxString errorReturns = ''.obs;

  // ===============================
  // RETURN EQUIPMENT - FETCH ACTIVE LOANS
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

      activeLoansForReturn.assignAll(
        (result as List).map((e) => Peminjaman.fromJson(e)).toList(),
      );
    } catch (e) {
      errorReturns.value = e.toString();
    } finally {
      isLoadingReturns.value = false;
    }
  }

  // ===============================
  // RETURN EQUIPMENT - SUBMIT RETURN REQUEST
  // ===============================
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

  // ===============================
  // HELPER - Get Late Items Count
  // ===============================
  int get lateItemsCount {
    final today = DateTime.now();
    return activeLoansForReturn.where((loan) {
      if (loan.tanggalJatuhTempo == null) return false;
      return today.isAfter(loan.tanggalJatuhTempo!);
    }).length;
  }

  // ===============================
  // HELPER - Check if Loan is Late
  // ===============================
  bool isLoanLate(Peminjaman loan) {
    if (loan.tanggalJatuhTempo == null) return false;
    return DateTime.now().isAfter(loan.tanggalJatuhTempo!);
  }

  // ===============================
  // HELPER - Check if Loan has Pending Return
  // ===============================
  bool hasPendingReturn(Peminjaman loan) {
    // Check if pengembalian exists in the loan data
    // This requires pengembalian to be included in the select query
    return false; // Will be handled by the view checking pengembalian list
  }

  // ===============================
  // HELPER - Get Pengembalian Status for Loan
  // ===============================
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

  // ===============================
  // STATE - LOAN HISTORY (RIWAYAT PEMINJAMAN)
  // ===============================
  final RxList<Peminjaman> loanHistory = <Peminjaman>[].obs;
  final RxBool isLoadingHistory = false.obs;
  final RxString errorHistory = ''.obs;

  // ===============================
  // LOAN HISTORY - FETCH ALL LOANS FOR CURRENT USER
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

      loanHistory.assignAll(
        (result as List).map((e) => Peminjaman.fromJson(e)).toList(),
      );
    } catch (e) {
      errorHistory.value = e.toString();
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ===============================
  // HELPER - Get Status Display Text
  // ===============================
  String getStatusDisplayText(Peminjaman loan) {
    switch (loan.status) {
      case StatusPeminjaman.menunggu:
        return 'Menunggu';
      case StatusPeminjaman.disetujui:
        // Check if overdue
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
