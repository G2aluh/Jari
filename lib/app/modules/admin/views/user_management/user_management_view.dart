import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/add_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/delete_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/edit_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/user_card.dart';
import 'package:flutter/material.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for users
    final List<Map<String, String>> users = [
      {'name': 'Admin Utama', 'role': 'Admin', 'email': 'admin@example.com'},
      {'name': 'Budi Santoso', 'role': 'Petugas', 'email': 'budi@example.com'},
      {'name': 'Siti Aminah', 'role': 'Peminjam', 'email': 'siti@example.com'},
      {'name': 'Rudi Hartono', 'role': 'Peminjam', 'email': 'rudi@example.com'},
      {'name': 'Dewi Lestari', 'role': 'Petugas', 'email': 'dewi@example.com'},
    ];

    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: ListView(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari pengguna...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Add User Button
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Tambah Pengguna'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.ungu,
                      foregroundColor: Warna.putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // User List
          ...users
              .map(
                (user) => UserCard(
                  user: user,
                  onEdit: () => _showEditDialog(context, user),
                  onDelete: () => _showDeleteDialog(context, user),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddUserDialog());
  }

  void _showEditDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => DeleteUserDialog(user: user),
    );
  }
}
