import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/user_management_controller.dart';
import 'package:jari/app/modules/admin/models/pengguna_model.dart';
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
    originalName = widget.user.nama;
    originalRole = widget.user.role.toLowerCase();
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

  void _showDeleteConfirmation(bool isTablet) {
    final titleSize = isTablet ? 20.0 : 16.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final smallSize = isTablet ? 14.0 : 12.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: isTablet ? 28 : 24,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              'Hapus Permanen',
              style: TextStyle(color: Colors.red, fontSize: titleSize),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus pengguna ini secara permanen?',
              style: TextStyle(color: Warna.putih, fontSize: bodySize),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Warna.putih.withOpacity(0.7),
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nama,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: bodySize,
                          ),
                        ),
                        Text(
                          widget.user.email,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: smallSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              '*Tindakan ini tidak dapat dibatalkan!',
              style: TextStyle(color: Colors.orange, fontSize: smallSize),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: bodySize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 12 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _handleDelete();
            },
            child: Text(
              'Hapus Permanen',
              style: TextStyle(color: Warna.putih, fontSize: bodySize),
            ),
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
    required bool isTablet,
  }) {
    final opacity = readOnly ? 0.3 : 0.5;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(readOnly ? 0.5 : 0.7),
        fontSize: isTablet ? 16 : 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Warna.putih.withOpacity(opacity),
        size: isTablet ? 24 : 20,
      ),
      errorStyle: TextStyle(
        color: Colors.red[300],
        fontSize: isTablet ? 14 : 12,
      ),
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet
        ? 500.0
        : MediaQuery.of(context).size.width * 0.9;
    final titleSize = isTablet ? 24.0 : 20.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final buttonPadding = isTablet ? 18.0 : 14.0;
    final contentPadding = isTablet ? 28.0 : 20.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.fromLTRB(
                contentPadding,
                spacing,
                isTablet ? 12 : 8,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Pengguna',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.7),
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  contentPadding,
                  spacing,
                  contentPadding,
                  0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email (read-only)
                      TextFormField(
                        initialValue: widget.user.email,
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: inputFontSize,
                        ),
                        readOnly: true,
                        decoration: _inputDecoration(
                          label: 'Email (tidak dapat diubah)',
                          icon: Icons.email,
                          readOnly: true,
                          isTablet: isTablet,
                        ),
                      ),
                      SizedBox(height: spacing),

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
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Row(
                children: [
                  // Hapus Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      onPressed: (isLoading || isDeleting)
                          ? null
                          : () => _showDeleteConfirmation(isTablet),
                      child: isDeleting
                          ? SizedBox(
                              width: isTablet ? 24 : 20,
                              height: isTablet ? 24 : 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              'Hapus',
                              style: TextStyle(fontSize: buttonFontSize),
                            ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  // Simpan Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSave ? Warna.ungu : Warna.abuAbu,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      onPressed: canSave ? _handleSave : null,
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
                              'Simpan',
                              style: TextStyle(
                                color: canSave
                                    ? Warna.putih
                                    : Warna.putih.withOpacity(0.5),
                                fontSize: buttonFontSize,
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
