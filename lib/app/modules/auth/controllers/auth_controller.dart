import 'package:jari/app/modules/auth/views/login_view.dart';
import 'package:jari/app/widgets/logout_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final _currentUserRole = ''.obs;
  final _isLoggedIn = false.obs;

  String get currentUserRole => _currentUserRole.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // Role constants
  static const String ADMIN = 'admin';
  static const String PETUGAS = 'petugas';
  static const String PEMINJAM = 'peminjam';

  final _supabase = Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        // Retrieve user data from 'pengguna' table
        final data = await _supabase
            .from('pengguna')
            .select('role, aktif')
            .eq('id', user.id)
            .maybeSingle();

        if (data == null) {
          print(
            "ERROR: User authenticated but no record found in 'public.pengguna' for ID: ${user.id}",
          );
          Get.snackbar(
            "Login Gagal",
            "Data profil tidak ditemukan. Hubungi Admin.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          );
          await _supabase.auth.signOut();
          return false;
        }

        // Cek apakah akun aktif
        final bool isActive = data['aktif'] as bool? ?? false;
        if (!isActive) {
          Get.snackbar(
            "Login Gagal",
            "Akun Anda telah dinonaktifkan. Hubungi Admin.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          );
          await _supabase.auth.signOut();
          return false;
        }

        final String role = data['role'] as String;

        // Handle role string mapping if needed (e.g. if DB returns capitalized)
        _currentUserRole.value = role.toLowerCase();
        _isLoggedIn.value = true;

        // Log aktivitas login
        try {
          await _supabase.rpc('log_user_login', params: {'p_user_id': user.id});
        } catch (_) {
          // Silent fail - jangan gagalkan login jika log gagal
        }

        update();
        return true;
      }
      return false;
    } on AuthException {
      Get.snackbar(
        "Login Gagal",
        "Email atau password salah",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return false;
    } catch (e) {
      Get.snackbar(
        "Login Gagal",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      );
      return false;
    }
  }

  // Logout function
  Future<void> logout() async {
    // Log aktivitas logout sebelum signOut
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        await _supabase.rpc('log_user_logout', params: {'p_user_id': userId});
      } catch (_) {
        // Silent fail
      }
    }

    await _supabase.auth.signOut();
    _isLoggedIn.value = false;
    _currentUserRole.value = '';
    Get.offAll(() => const LoginView());
  }

  void showLogoutConfirmation() {
    Get.dialog(
      LogoutConfirmationDialog(
        onConfirm: () {
          logout();
        },
      ),
    );
  }

  // Check if user has a specific role
  bool hasRole(String role) {
    return _currentUserRole.value == role;
  }
}
