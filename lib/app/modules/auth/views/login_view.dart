import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController _authController = Get.find();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo/title
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: Text(
                      'Sistem Peminjaman Alat',
                      style: AppTextStyles.primaryText.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Username Field
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _usernameController,
                    style: TextStyle(color: Warna.putih),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: Warna.hitamTransparan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.ungu, width: 2),
                      ),
                      prefixIcon: Icon(Icons.person, color: Warna.putih),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan username';
                      }
                      return null;
                    },
                  ),
                ),

                // Password Field
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Warna.putih),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: Warna.hitamTransparan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.ungu, width: 2),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Warna.putih),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan password';
                      }
                      return null;
                    },
                  ),
                ),

                // Role Selection Dropdown
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole.isEmpty ? null : _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Pilih Peran',
                      labelStyle: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: Warna.hitamTransparan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Warna.ungu, width: 2),
                      ),
                    ),
                    dropdownColor: Warna.hitamTransparan,
                    style: TextStyle(color: Warna.putih),
                    items: [
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(
                        value: 'petugas',
                        child: Text('Petugas'),
                      ),
                      DropdownMenuItem(
                        value: 'peminjam',
                        child: Text('Peminjam'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih peran anda';
                      }
                      return null;
                    },
                  ),
                ),

                // Login Button
                Obx(() {
                  return ElevatedButton(
                    onPressed: _authController.isLoggedIn
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedRole.isNotEmpty) {
                                final success = await _authController.login(
                                  _usernameController.text.trim(),
                                  _passwordController.text,
                                  _selectedRole,
                                );

                                if (success) {
                                  // Navigate to role-specific dashboard
                                  switch (_selectedRole) {
                                    case 'admin':
                                      Get.offAllNamed('/admin-dashboard');
                                      break;
                                    case 'petugas':
                                      Get.offAllNamed('/petugas-dashboard');
                                      break;
                                    case 'peminjam':
                                      Get.offAllNamed('/peminjam-dashboard');
                                      break;
                                  }
                                } else {
                                  Get.snackbar(
                                    'Gagal',
                                    'Login gagal. Silakan coba lagi.',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  'Peringatan',
                                  'Silakan pilih peran terlebih dahulu.',
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.ungu,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _authController.isLoggedIn
                        ? CircularProgressIndicator(color: Warna.putih)
                        : Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Warna.putih,
                            ),
                          ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
