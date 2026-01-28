import 'package:benang_merah/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Observable list of users
  final RxList<Pengguna> users = <Pengguna>[].obs;
  final RxList<Pengguna> filteredUsers = <Pengguna>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetch all users from Supabase
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('pengguna')
          .select()
          .order('dibuat_pada', ascending: false);

      users.value = (response as List)
          .map((json) => Pengguna.fromJson(json))
          .toList();
      _applySearch();
    } catch (e) {
      _showError('Gagal memuat data pengguna: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search users by name or email
  void searchUsers(String query) {
    searchQuery.value = query;
    _applySearch();
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredUsers.value = users.toList();
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredUsers.value = users
          .where(
            (user) =>
                user.nama.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  /// Add new user menggunakan auth.signUp
  Future<bool> addUser({
    required String email,
    required String password,
    required String nama,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      // Simpan session admin saat ini
      final currentSession = _supabase.auth.currentSession;

      // Buat user baru dengan signUp
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nama': nama},
      );

      if (response.user == null) {
        _showError('Gagal membuat akun pengguna');
        return false;
      }

      final newUserId = response.user!.id;

      // Tunggu sebentar agar trigger database selesai (jika ada)
      await Future.delayed(const Duration(milliseconds: 500));

      // Cek apakah user sudah ada di pengguna (dari trigger)
      final existing = await _supabase
          .from('pengguna')
          .select('id')
          .eq('id', newUserId)
          .maybeSingle();

      if (existing != null) {
        // Update data jika sudah ada
        await _supabase
            .from('pengguna')
            .update({
              'nama': nama,
              'email': email,
              'role': role.toLowerCase(),
              'aktif': true,
            })
            .eq('id', newUserId);
      } else {
        // Insert baru jika belum ada
        await _supabase.from('pengguna').insert({
          'id': newUserId,
          'nama': nama,
          'email': email,
          'role': role.toLowerCase(),
          'aktif': true,
        });
      }

      // Restore session admin
      if (currentSession != null) {
        await _supabase.auth.setSession(currentSession.refreshToken!);
      }

      await fetchUsers();
      _showSuccess('Pengguna berhasil ditambahkan');
      return true;
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        _showError('Email sudah terdaftar');
      } else {
        _showError('Gagal membuat pengguna: ${e.message}');
      }
      return false;
    } catch (e) {
      _showError('Gagal membuat pengguna: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing user
  Future<bool> updateUser({
    required String id,
    required String nama,
    required String role,
    required bool aktif,
  }) async {
    try {
      isLoading.value = true;

      await _supabase
          .from('pengguna')
          .update({'nama': nama, 'role': role.toLowerCase(), 'aktif': aktif})
          .eq('id', id);

      await fetchUsers();
      _showSuccess('Pengguna berhasil diperbarui');
      return true;
    } catch (e) {
      _showError('Gagal memperbarui pengguna: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user (set aktif = false for soft delete)
  Future<bool> deleteUser(String id) async {
    try {
      isLoading.value = true;

      // Soft delete - set aktif = false
      await _supabase.from('pengguna').update({'aktif': false}).eq('id', id);

      await fetchUsers();
      _showSuccess('Pengguna berhasil dinonaktifkan');
      return true;
    } catch (e) {
      _showError('Gagal menghapus pengguna: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Activate user (set aktif = true)
  Future<bool> activateUser(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('pengguna').update({'aktif': true}).eq('id', id);

      await fetchUsers();
      _showSuccess('Pengguna berhasil diaktifkan');
      return true;
    } catch (e) {
      _showError('Gagal mengaktifkan pengguna: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Hard delete user (permanent)
  Future<bool> hardDeleteUser(String id) async {
    try {
      isLoading.value = true;

      await _supabase.from('pengguna').delete().eq('id', id);

      await fetchUsers();
      _showSuccess('Pengguna berhasil dihapus permanen');
      return true;
    } catch (e) {
      _showError('Gagal menghapus pengguna: $e');
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
