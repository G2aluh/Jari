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
  bool isDeleting = false;

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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Permanen', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus pengguna ini secara permanen?',
              style: TextStyle(color: Warna.putih),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Warna.putih.withOpacity(0.7)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nama,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.user.email,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              '⚠️ Tindakan ini tidak dapat dibatalkan!',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Warna.putih.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _handleDelete();
            },
            child: Text('Hapus Permanen', style: TextStyle(color: Warna.putih)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete() async {
    setState(() => isDeleting = true);

    try {
      await widget.controller.hardDeleteUser(widget.user.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => isDeleting = false);
      }
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
    final canSave = hasChanges && !isLoading && !isDeleting;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Pengguna',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                        decoration: _inputDecoration(
                          label: 'Role',
                          icon: Icons.badge,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'admin',
                            child: Text('Admin'),
                          ),
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
                          if (value != null) {
                            setState(() => selectedRole = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // Hapus Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: (isLoading || isDeleting)
                          ? null
                          : _showDeleteConfirmation,
                      child: isDeleting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Text('Hapus'),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Simpan Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSave ? Warna.ungu : Warna.abuAbu,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
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
                                color: canSave
                                    ? Warna.putih
                                    : Warna.putih.withOpacity(0.5),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
