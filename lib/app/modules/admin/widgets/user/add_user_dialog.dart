import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/user_management_controller.dart';
import 'package:flutter/material.dart';

class AddUserDialog extends StatefulWidget {
  final UserManagementController controller;

  const AddUserDialog({super.key, required this.controller});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'petugas';
  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    final success = await widget.controller.addUser(
      email: emailController.text.trim(),
      password: passwordController.text,
      nama: nameController.text.trim(),
      role: selectedRole,
    );

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    required bool isTablet,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(0.7),
        fontSize: isTablet ? 16 : 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Warna.putih.withOpacity(0.5),
        size: isTablet ? 24 : 20,
      ),
      suffixIcon: suffixIcon,
      errorStyle: TextStyle(
        color: Colors.red[300],
        fontSize: isTablet ? 14 : 12,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.ungu),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 450.0 : 320.0;
    final titleSize = isTablet ? 22.0 : 18.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final buttonPadding = isTablet ? 16.0 : 12.0;
    final contentPadding = isTablet ? 28.0 : 24.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Pengguna',
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name field
                    TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        label: 'Nama Lengkap',
                        icon: Icons.person,
                        isTablet: isTablet,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Email field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        label: 'Email',
                        icon: Icons.email,
                        isTablet: isTablet,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!_isValidEmail(value.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        label: 'Password',
                        icon: Icons.lock,
                        isTablet: isTablet,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Warna.putih.withOpacity(0.5),
                            size: isTablet ? 24 : 20,
                          ),
                          onPressed: () {
                            setState(() => obscurePassword = !obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Role dropdown
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      dropdownColor: Warna.abuAbu,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        label: 'Role',
                        icon: Icons.badge,
                        isTablet: isTablet,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'admin',
                          child: Text(
                            'Admin',
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'petugas',
                          child: Text(
                            'Petugas',
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'peminjam',
                          child: Text(
                            'Peminjam',
                            style: TextStyle(fontSize: inputFontSize),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedRole = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing + 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPadding,
                        vertical: buttonPadding / 2,
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.ungu,
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonPadding * 1.5,
                        vertical: buttonPadding,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleAdd,
                    child: isLoading
                        ? SizedBox(
                            width: isTablet ? 24 : 20,
                            height: isTablet ? 24 : 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Warna.putih,
                            ),
                          )
                        : Text(
                            'Tambah',
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}
