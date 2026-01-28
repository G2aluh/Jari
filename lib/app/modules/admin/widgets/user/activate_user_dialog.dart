import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/user_management_controller.dart';
import 'package:benang_merah/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';

class ActivateUserDialog extends StatefulWidget {
  final Pengguna user;
  final UserManagementController controller;

  const ActivateUserDialog({
    super.key,
    required this.user,
    required this.controller,
  });

  @override
  State<ActivateUserDialog> createState() => _ActivateUserDialogState();
}

class _ActivateUserDialogState extends State<ActivateUserDialog> {
  bool isLoading = false;

  Future<void> _handleActivate() async {
    setState(() => isLoading = true);

    final success = await widget.controller.activateUser(widget.user.id);

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
          Text('Aktifkan Pengguna', style: TextStyle(color: Warna.putih)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah Anda yakin ingin mengaktifkan kembali pengguna ini?',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
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
            '*Pengguna akan dapat login kembali.',
            style: TextStyle(
              color: Colors.green,
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
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isLoading ? null : _handleActivate,
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
                  'Aktifkan',
                  style: TextStyle(
                    color: Warna.putih,
                  ),
                ),
        ),
      ],
    );
  }
}
