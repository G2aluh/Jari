import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/user_management_controller.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/activate_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/add_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/delete_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/edit_user_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(UserManagementController());

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            onChanged: controller.searchUsers,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, controller),
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
          SizedBox(height: 24),

          // User List
          Obx(() {
            if (controller.isLoading.value && controller.users.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(color: Warna.ungu),
                ),
              );
            }

            if (controller.filteredUsers.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    'Tidak ada pengguna ditemukan',
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                ),
              );
            }

            return Column(
              children: controller.filteredUsers.map((user) {
                return UserCard(
                  user: user,
                  onEdit: () => _showEditDialog(context, controller, user),
                  onToggleStatus: () =>
                      _showToggleStatusDialog(context, controller, user),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    UserManagementController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddUserDialog(controller: controller),
    );
  }

  void _showEditDialog(
    BuildContext context,
    UserManagementController controller,
    dynamic user,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user, controller: controller),
    );
  }

  void _showToggleStatusDialog(
    BuildContext context,
    UserManagementController controller,
    dynamic user,
  ) {
    if (user.aktif) {
      // User aktif → tampilkan dialog nonaktifkan
      showDialog(
        context: context,
        builder: (context) =>
            DeleteUserDialog(user: user, controller: controller),
      );
    } else {
      // User nonaktif → tampilkan dialog aktifkan
      showDialog(
        context: context,
        builder: (context) =>
            ActivateUserDialog(user: user, controller: controller),
      );
    }
  }
}
