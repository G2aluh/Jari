import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController extends GetxController {
  final _supabase = Supabase.instance.client;

  final categories = <KategoriAlat>[].obs;
  final filteredCategories = <KategoriAlat>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('kategori_alat')
          .select()
          .order('nama_kategori', ascending: true);

      categories.value = (response as List)
          .map((e) => KategoriAlat.fromJson(e))
          .toList();
      _applyFilter();
    } catch (e) {
      _showError('Gagal memuat kategori: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search categories
  void searchCategories(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories.where((cat) {
        return cat.namaKategori.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        );
      }).toList();
    }
  }

  /// Add new category
  Future<bool> addCategory({
    required String namaKategori,
    String? deskripsi,
    int iconCode = 0,
    String iconFamily = 'MaterialIcons',
    String? iconPackage,
  }) async {
    try {
      isLoading.value = true;

      await _supabase.from('kategori_alat').insert({
        'nama_kategori': namaKategori,
        'deskripsi': deskripsi,
        'icon_code': iconCode,
        'icon_family': iconFamily,
        'icon_package': iconPackage,
      });

      await fetchCategories();
      _showSuccess('Kategori berhasil ditambahkan');
      return true;
    } catch (e) {
      _showError('Gagal menambah kategori: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update category
  Future<bool> updateCategory({
    required String id,
    required String namaKategori,
    String? deskripsi,
    int iconCode = 0,
    String iconFamily = 'MaterialIcons',
    String? iconPackage,
  }) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('kategori_alat')
          .update({
            'nama_kategori': namaKategori,
            'deskripsi': deskripsi,
            'icon_code': iconCode,
            'icon_family': iconFamily,
            'icon_package': iconPackage,
          })
          .eq('id', id);

      await fetchCategories();
      _showSuccess('Kategori berhasil diperbarui');
      return true;
    } catch (e) {
      _showError('Gagal memperbarui kategori: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete category
  Future<bool> deleteCategory(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('kategori_alat').delete().eq('id', id);

      await fetchCategories();
      _showSuccess('Kategori berhasil dihapus');
      return true;
    } catch (e) {
      _showError('Gagal menghapus kategori: $e');
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
      margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
    );
  }
}
