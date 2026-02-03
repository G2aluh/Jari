import 'package:jari/app/modules/admin/models/alat_model.dart';
import 'package:jari/app/modules/admin/models/detail_peminjaman_model.dart';
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

  // List of alat (untuk dropdown selection)
  final RxList<Alat> alatList = <Alat>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPeminjaman();
    fetchPeminjamList();
    fetchAlatList();
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

  /// Fetch list of available alat
  Future<void> fetchAlatList() async {
    try {
      final response = await _supabase
          .from('alat')
          .select()
          .eq('aktif', true)
          .gt('stok_tersedia', 0) // Hanya ambil yang ada stok
          .order('nama_alat');

      alatList.value = (response as List)
          .map((json) => Alat.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching alat list: $e');
    }
  }

  /// Fetch detail peminjaman for a specific loan
  Future<List<DetailPeminjaman>> fetchDetailPeminjaman(
    String peminjamanId,
  ) async {
    try {
      final response = await _supabase
          .from('detail_peminjaman')
          .select('*, alat:alat_id(*)')
          .eq('peminjaman_id', peminjamanId);

      return (response as List)
          .map((json) => DetailPeminjaman.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching detail peminjaman: $e');
      return [];
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
    required List<AlatSelection> selectedAlat,
  }) async {
    try {
      isLoading.value = true;

      // 1. Insert ke tabel peminjaman
      final peminjamanResponse = await _supabase
          .from('peminjaman')
          .insert({
            'peminjam_id': peminjamId,
            'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T').first,
            'tanggal_jatuh_tempo': tanggalJatuhTempo
                .toIso8601String()
                .split('T')
                .first,
            'status': 'menunggu',
          })
          .select()
          .single();

      final peminjamanIdNew = peminjamanResponse['id'] as String;

      // 2. Insert ke detail_peminjaman untuk setiap alat
      for (var selection in selectedAlat) {
        await _supabase.from('detail_peminjaman').insert({
          'peminjaman_id': peminjamanIdNew,
          'alat_id': selection.alat.id,
          'jumlah': selection.jumlah,
        });

        // Note: Stok updates handed by DB trigger or manual if needed later

        // 3. Update Stok (Decrement) via RPC
        await _supabase.rpc(
          'decrement_stock',
          params: {
            'p_alat_id': selection.alat.id,
            'p_jumlah': selection.jumlah,
          },
        );
      }

      await fetchPeminjaman();
      _showSuccess('Peminjaman berhasil ditambahkan');
      return true;
    } catch (e) {
      _showError('Gagal menambah peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
      // Refresh alat list karena stok mungkin berubah
      fetchAlatList();
    }
  }

  /// Update existing peminjaman
  Future<bool> updatePeminjaman({
    required String id,
    StatusPeminjaman? status,
    DateTime? tanggalJatuhTempo,
    String? catatanPenolakan,
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
      if (petugasId != null) {
        updateData['petugas_id'] = petugasId;
      }

      // Update data utama peminjaman
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

  /// Update detail item peminjaman (tambah/hapus/edit jumlah)
  Future<bool> updateLoanItems(
    String peminjamanId,
    List<AlatSelection> newItems,
  ) async {
    try {
      isLoading.value = true;

      // 1. Ambil existing items
      final existingItems = await fetchDetailPeminjaman(peminjamanId);

      // 2. Tentukan items yang harus dihapus (ada di existing tapi tidak di new)
      final itemsToDelete = existingItems.where((existing) {
        return !newItems.any((newI) => newI.alat.id == existing.alatId);
      }).toList();

      // 3. Tentukan items yang harus ditambah atau diupdate
      for (var item in newItems) {
        final existingItem = existingItems.firstWhereOrNull(
          (e) => e.alatId == item.alat.id,
        );

        if (existingItem == null) {
          // INSERT NEW
          await _supabase.from('detail_peminjaman').insert({
            'peminjaman_id': peminjamanId,
            'alat_id': item.alat.id,
            'jumlah': item.jumlah,
          });

          // Decrement Stock
          await _supabase.rpc(
            'decrement_stock',
            params: {'p_alat_id': item.alat.id, 'p_jumlah': item.jumlah},
          );
        } else if (existingItem.jumlah != item.jumlah) {
          // UPDATE JUMLAH
          await _supabase
              .from('detail_peminjaman')
              .update({'jumlah': item.jumlah})
              .eq('id', existingItem.id);

          // Adjust Stock
          final diff = item.jumlah - existingItem.jumlah;
          if (diff > 0) {
            // Increased quantity -> Decrement stock
            await _supabase.rpc(
              'decrement_stock',
              params: {'p_alat_id': item.alat.id, 'p_jumlah': diff},
            );
          } else {
            // Decreased quantity -> Increment stock
            await _supabase.rpc(
              'increment_stock',
              params: {'p_alat_id': item.alat.id, 'p_jumlah': diff.abs()},
            );
          }
        }
      }

      // 4. Eksekusi hapus
      for (var item in itemsToDelete) {
        await _supabase.from('detail_peminjaman').delete().eq('id', item.id);

        // Increment Stock (Return)
        await _supabase.rpc(
          'increment_stock',
          params: {'p_alat_id': item.alatId, 'p_jumlah': item.jumlah},
        );
      }

      return true;
    } catch (e) {
      _showError('Gagal update item peminjaman: $e');
      return false;
    } finally {
      isLoading.value = false;
      fetchAlatList(); // refresh stok
    }
  }

  /// Delete peminjaman
  Future<bool> deletePeminjaman(String id) async {
    try {
      isLoading.value = true;

      // Hapus detail terlebih dahulu (jika tidak cascade delete)
      await _supabase
          .from('detail_peminjaman')
          .delete()
          .eq('peminjaman_id', id);

      // Hapus header peminjaman
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
