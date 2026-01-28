import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/user_management_controller.dart';
import 'package:benang_merah/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';

class EditUserDialog extends StatefulWidget {
  final Pengguna user;
  final UserManagementController controller;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.controller,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late String selectedRole;
  late String originalName;
  late String originalRole;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.nama);
    selectedRole = widget.user.role.toLowerCase();
    // Simpan nilai asli untuk perbandingan
    originalName = widget.user.nama;
    originalRole = widget.user.role.toLowerCase();
    // Listener untuk detect perubahan
    nameController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    nameController.removeListener(_checkChanges);
    nameController.dispose();
    super.dispose();
  }

  void _checkChanges() {
    setState(() {});
  }

  bool get hasChanges {
    return nameController.text.trim() != originalName ||
        selectedRole != originalRole;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    final success = await widget.controller.updateUser(
      id: widget.user.id,
      nama: nameController.text.trim(),
      role: selectedRole,
      aktif: widget.user.aktif,
    );

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    final opacity = readOnly ? 0.3 : 0.5;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(readOnly ? 0.5 : 0.7),
      ),
      prefixIcon: Icon(icon, color: Warna.putih.withOpacity(opacity)),
      errorStyle: TextStyle(color: Colors.red[300]),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.putih.withOpacity(opacity)),
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
    final canSave = hasChanges && !isLoading;

    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text('Edit Pengguna', style: TextStyle(color: Warna.putih)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email (read-only)
              TextFormField(
                initialValue: widget.user.email,
                style: TextStyle(color: Warna.putih.withOpacity(0.5)),
                readOnly: true,
                decoration: _inputDecoration(
                  label: 'Email (tidak dapat diubah)',
                  icon: Icons.email,
                  readOnly: true,
                ),
              ),
              SizedBox(height: 16),

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
            backgroundColor: canSave ? Warna.ungu : Warna.abuAbu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: canSave ? _handleSave : null,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Warna.putih,
                  ),
                )
              : Text(
                  'Simpan',
                  style: TextStyle(
                    color: canSave ? Warna.putih : Warna.putih.withOpacity(0.5),
                  ),
                ),
        ),
      ],
    );
  }
}
