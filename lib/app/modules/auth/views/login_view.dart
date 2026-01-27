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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/login-logo3.png',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        'Masuk Ke Dalam Aplikasi',
                        style: AppTextStyles.primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        labelText: 'Email',
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
                        prefixIcon: Icon(Icons.email, color: Warna.putih),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Format email tidak valid';
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

                      //mata terbuka
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
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
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
                                final success = await _authController.login(
                                  _usernameController.text.trim(),
                                  _passwordController.text,
                                );

                                if (success) {
                                  // Navigate to role-specific dashboard based on role from DB
                                  switch (_authController.currentUserRole) {
                                    case 'admin':
                                      Get.offAllNamed('/admin-dashboard');
                                      break;
                                    case 'petugas':
                                      Get.offAllNamed('/petugas-dashboard');
                                      break;
                                    case 'peminjam':
                                      Get.offAllNamed('/peminjam-dashboard');
                                      break;
                                    default:
                                      Get.snackbar(
                                        'Error',
                                        'Role tidak dikenali',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                  }
                                } else {
                                  // Error handling is already done in AuthController
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.ungu,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _authController.isLoggedIn
                          ? CircularProgressIndicator(color: Warna.putih)
                          : Text(
                              'Masuk',
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
