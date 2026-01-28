import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/user_management_controller.dart';
import 'package:benang_merah/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';

class DeleteUserDialog extends StatefulWidget {
  final Pengguna user;
  final UserManagementController controller;

  const DeleteUserDialog({
    super.key,
    required this.user,
    required this.controller,
  });

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  bool isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => isLoading = true);

    final success = await widget.controller.deleteUser(widget.user.id);

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Row(
        children: [
          Text('Nonaktifkan Pengguna', style: TextStyle(color: Warna.putih)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah Anda yakin ingin menonaktifkan pengguna ini?',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 16),

          // User info card
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Warna.ungu.withOpacity(0.2),
                  child: Text(
                    widget.user.nama.isNotEmpty
                        ? widget.user.nama[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Warna.ungu,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      SizedBox(height: 2),
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
            '*Pengguna akan dinonaktifkan dan tidak dapat login.',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
            ),
          ),
        ],
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
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isLoading ? null : _handleDelete,
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
                  'Nonaktifkan',
                  style: TextStyle(
                    color: Warna.putih,
                  ),
                ),
        ),
      ],
    );
  }
}
