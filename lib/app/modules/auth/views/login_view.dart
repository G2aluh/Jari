import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool _obsecuredPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
            final maxWidth = isTablet ? 500.0 : double.infinity;
            final padding = isTablet ? 40.0 : 24.0;
            final logoSize = isTablet ? 200.0 : 150.0;
            final titleSize = isTablet ? 24.0 : 20.0;
            final buttonPadding = isTablet ? 20.0 : 18.0;
            final fieldSpacing = isTablet ? 20.0 : 16.0;

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/login-logo3.png',
                                height: logoSize,
                                width: logoSize,
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 32 : 24),

                          // Title
                          Container(
                            margin: EdgeInsets.only(bottom: fieldSpacing),
                            child: Center(
                              child: Text(
                                'Masuk Ke Dalam Aplikasi',
                                style: AppTextStyles.primaryText.copyWith(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          // Username Field
                          Container(
                            margin: EdgeInsets.only(bottom: fieldSpacing),
                            child: TextFormField(
                              controller: _usernameController,
                              style: TextStyle(
                                color: Warna.putih,
                                fontSize: isTablet ? 16 : 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Warna.putih.withOpacity(0.7),
                                  fontSize: isTablet ? 16 : 14,
                                ),
                                filled: true,
                                fillColor: Warna.hitamTransparan,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isTablet ? 18 : 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Warna.ungu,
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  IconlyBold.message,
                                  color: Warna.putih,
                                  size: isTablet ? 24 : 22,
                                ),
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
                            margin: EdgeInsets.only(bottom: isTablet ? 32 : 24),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obsecuredPassword,
                              style: TextStyle(
                                color: Warna.putih,
                                fontSize: isTablet ? 16 : 14,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Warna.putih.withOpacity(0.7),
                                  fontSize: isTablet ? 16 : 14,
                                ),
                                filled: true,
                                fillColor: Warna.hitamTransparan,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isTablet ? 18 : 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Warna.ungu,
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  IconlyBold.lock,
                                  color: Warna.putih,
                                  size: isTablet ? 24 : 22,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obsecuredPassword
                                        ? IconlyBold.hide
                                        : IconlyBold.show,
                                    color: Warna.putih,
                                    size: isTablet ? 24 : 22,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obsecuredPassword = !_obsecuredPassword;
                                    });
                                  },
                                ),
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
                                        final success = await _authController
                                            .login(
                                              _usernameController.text.trim(),
                                              _passwordController.text,
                                            );

                                        if (success) {
                                          switch (_authController
                                              .currentUserRole) {
                                            case 'admin':
                                              Get.offAllNamed(
                                                '/admin-dashboard',
                                              );
                                              break;
                                            case 'petugas':
                                              Get.offAllNamed(
                                                '/petugas-dashboard',
                                              );
                                              break;
                                            case 'peminjam':
                                              Get.offAllNamed(
                                                '/peminjam-dashboard',
                                              );
                                              break;
                                            default:
                                              Get.snackbar(
                                                'Error',
                                                'Role tidak dikenali',
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                margin: const EdgeInsets.only(
                                                  bottom: 12,
                                                  left: 12,
                                                  right: 12,
                                                ),
                                              );
                                          }
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Warna.ungu,
                                padding: EdgeInsets.symmetric(
                                  vertical: buttonPadding,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _authController.isLoggedIn
                                  ? CircularProgressIndicator(
                                      color: Warna.putih,
                                    )
                                  : Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: isTablet ? 18 : 16,
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
          },
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
