import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/user_management_controller.dart';
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
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Warna.putih.withOpacity(0.5)),
      suffixIcon: suffixIcon,
      errorStyle: TextStyle(color: Colors.red[300]),
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
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text('Tambah Pengguna', style: TextStyle(color: Warna.putih)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              TextFormField(
                controller: nameController,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration(
                  label: 'Nama Lengkap',
                  icon: Icons.person,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration(label: 'Email', icon: Icons.email),
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
              SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration(
                  label: 'Password',
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Warna.putih.withOpacity(0.5),
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
              SizedBox(height: 16),

              // Role dropdown
              DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: Warna.abuAbu,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration(label: 'Role', icon: Icons.badge),
                items: [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'petugas', child: Text('Petugas')),
                  DropdownMenuItem(value: 'peminjam', child: Text('Peminjam')),
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
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Warna.ungu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isLoading ? null : _handleAdd,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Warna.putih,
                  ),
                )
              : Text('Tambah', style: TextStyle(color: Warna.putih)),
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}
