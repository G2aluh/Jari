import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jari/app/modules/peminjam/views/dialog/pengajuan_peminjaman_dialog.dart';

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
    searchController.addListener(_applyFilters);
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
  // SEARCH & FILTER
  // ===============================
  void toggleSearch() {
    if (isSearchActive.value) {
      isSearchActive.value = false;
      searchController.clear();
    } else {
      isSearchActive.value = true;
    }
  }

  void _applyFilters() {
    final search = searchController.text.trim().toLowerCase();
    final kategori = selectedKategoriId.value;

    var filtered = allAlat.toList();

    // Filter by category
    if (kategori.isNotEmpty) {
      filtered = filtered.where((a) => a['kategori_id'] == kategori).toList();
    }

    // Filter by search
    if (search.isNotEmpty) {
      filtered = filtered.where((a) {
        final nama = (a['nama_alat'] as String).toLowerCase();
        return nama.contains(search);
      }).toList();
    }

    alatList.assignAll(filtered);
  }

  void filterByKategori(String kategoriId) {
    selectedKategoriId.value = kategoriId;
    _applyFilters();
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
  // NAVIGATION DIALOG
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
}
