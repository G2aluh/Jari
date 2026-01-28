import 'dart:async';
import 'dart:typed_data';
import 'package:benang_merah/app/modules/admin/models/alat_model.dart';
import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EquipmentController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _imagePicker = ImagePicker();

  final equipments = <Alat>[].obs;
  final filteredEquipments = <Alat>[].obs;
  final categories = <KategoriAlat>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // For image upload - using XFile for cross-platform support
  final selectedImageFile = Rxn<XFile>();
  final isUploading = false.obs;

  static const String _bucketName = 'alat-images';

  // Realtime subscriptions
  RealtimeChannel? _alatChannel;
  RealtimeChannel? _kategoriChannel;

  @override
  void onInit() {
    super.onInit();
    fetchEquipments();
    fetchCategories();
    _setupRealtimeSubscriptions();
  }

  @override
  void onClose() {
    _alatChannel?.unsubscribe();
    _kategoriChannel?.unsubscribe();
    super.onClose();
  }

  /// Setup realtime subscriptions for alat and kategori tables
  void _setupRealtimeSubscriptions() {
    // Subscribe to alat table changes
    _alatChannel = _supabase
        .channel('alat_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'alat',
          callback: (payload) {
            debugPrint('Realtime alat: ${payload.eventType}');
            fetchEquipments(); // Refresh list on any change
          },
        )
        .subscribe();

    // Subscribe to kategori_alat table changes
    _kategoriChannel = _supabase
        .channel('kategori_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'kategori_alat',
          callback: (payload) {
            debugPrint('Realtime kategori: ${payload.eventType}');
            fetchCategories(); // Refresh categories on any change
          },
        )
        .subscribe();
  }

  /// Fetch all equipments with category relation
  Future<void> fetchEquipments() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('alat')
          .select('*, kategori_alat(*)')
          .order('nama_alat', ascending: true);

      equipments.value = (response as List)
          .map((e) => Alat.fromJson(e))
          .toList();
      _applyFilter();
    } catch (e) {
      _showError('Gagal memuat alat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all categories for dropdown
  Future<void> fetchCategories() async {
    try {
      debugPrint('Fetching categories from kategori_alat table...');

      final response = await _supabase.from('kategori_alat').select();

      debugPrint('Categories response: $response');

      categories.value = (response as List)
          .map((e) => KategoriAlat.fromJson(e))
          .toList();

      debugPrint('Loaded ${categories.length} categories');
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      _showError('Gagal memuat kategori: $e');
    }
  }

  /// Search equipments
  void searchEquipments(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredEquipments.value = equipments;
    } else {
      filteredEquipments.value = equipments.where((alat) {
        final query = searchQuery.value.toLowerCase();
        return alat.namaAlat.toLowerCase().contains(query) ||
            alat.kodeAlat.toLowerCase().contains(query) ||
            alat.namaKategori.toLowerCase().contains(query);
      }).toList();
    }
  }

  /// Pick image from gallery - cross-platform (mobile & web)
  Future<XFile?> pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedImageFile.value = pickedFile;
        return pickedFile;
      }
      return null;
    } catch (e) {
      _showError('Gagal memilih gambar: $e');
      return null;
    }
  }

  /// Upload image to Supabase Storage - cross-platform support
  Future<String?> uploadImage(XFile imageFile, String kodeAlat) async {
    try {
      isUploading.value = true;

      // Get file extension from name
      final fileName = imageFile.name;
      final ext = fileName.contains('.')
          ? '.${fileName.split('.').last}'
          : '.jpg';
      final uploadFileName =
          '${kodeAlat}_${DateTime.now().millisecondsSinceEpoch}$ext';

      // Read as bytes for cross-platform compatibility
      final Uint8List bytes = await imageFile.readAsBytes();

      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            uploadFileName,
            bytes,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: true,
              contentType: 'image/${ext.replaceAll('.', '')}',
            ),
          );

      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(uploadFileName);

      return publicUrl;
    } catch (e) {
      _showError('Gagal upload gambar: $e');
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete image from Supabase Storage
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract file name from URL
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      if (segments.isEmpty) return false;

      final fileName = segments.last;

      await _supabase.storage.from(_bucketName).remove([fileName]);
      return true;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Add new equipment
  Future<bool> addEquipment({
    required String kodeAlat,
    required String namaAlat,
    String? kategoriId,
    required int stokTotal,
    XFile? imageFile,
  }) async {
    try {
      isLoading.value = true;

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile, kodeAlat);
      }

      await _supabase.from('alat').insert({
        'kode_alat': kodeAlat,
        'nama_alat': namaAlat,
        'kategori_id': kategoriId,
        'stok_total': stokTotal,
        'stok_tersedia': stokTotal,
        'aktif': true,
        'alat_url': imageUrl,
      });

      selectedImageFile.value = null;
      // Realtime will handle refresh
      _showSuccess('Alat berhasil ditambahkan');
      return true;
    } catch (e) {
      _showError('Kode alat sudah ada.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update equipment
  Future<bool> updateEquipment({
    required String id,
    required String kodeAlat,
    required String namaAlat,
    String? kategoriId,
    required int stokTotal,
    required int stokTersedia,
    bool aktif = true,
    String? existingImageUrl,
    XFile? newImageFile,
  }) async {
    try {
      isLoading.value = true;

      String? imageUrl = existingImageUrl;

      // If new image selected, upload and delete old one
      if (newImageFile != null) {
        // Delete old image if exists
        if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
          await deleteImage(existingImageUrl);
        }
        // Upload new image
        imageUrl = await uploadImage(newImageFile, kodeAlat);
      }

      await _supabase
          .from('alat')
          .update({
            'kode_alat': kodeAlat,
            'nama_alat': namaAlat,
            'kategori_id': kategoriId,
            'stok_total': stokTotal,
            'stok_tersedia': stokTersedia,
            'aktif': aktif,
            'alat_url': imageUrl,
          })
          .eq('id', id);

      selectedImageFile.value = null;
      // Realtime will handle refresh
      _showSuccess('Alat berhasil diperbarui');
      return true;
    } catch (e) {
      _showError('Gagal memperbarui alat: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Soft delete equipment (set aktif = false)
  Future<bool> deleteEquipment(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('alat').update({'aktif': false}).eq('id', id);

      // Realtime will handle refresh
      _showSuccess('Alat berhasil dinonaktifkan');
      return true;
    } catch (e) {
      _showError('Gagal menonaktifkan alat: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Activate equipment
  Future<bool> activateEquipment(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('alat').update({'aktif': true}).eq('id', id);

      // Realtime will handle refresh
      _showSuccess('Alat berhasil diaktifkan');
      return true;
    } catch (e) {
      _showError('Gagal mengaktifkan alat: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Hard delete equipment (permanent)
  Future<bool> hardDeleteEquipment(String id, {String? imageUrl}) async {
    try {
      isLoading.value = true;

      // Delete image from storage if exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        await deleteImage(imageUrl);
      }

      // Delete from database
      await _supabase.from('alat').delete().eq('id', id);

      // Realtime will handle refresh
      _showSuccess('Alat berhasil dihapus permanen');
      return true;
    } catch (e) {
      _showError('Gagal menghapus alat: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearSelectedImage() {
    selectedImageFile.value = null;
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
