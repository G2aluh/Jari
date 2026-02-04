import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/user_management_controller.dart';
import 'package:jari/app/modules/admin/widgets/user/activate_user_dialog.dart';
import 'package:jari/app/modules/admin/widgets/user/add_user_dialog.dart';
import 'package:jari/app/modules/admin/widgets/user/delete_user_dialog.dart';
import 'package:jari/app/modules/admin/widgets/user/edit_user_dialog.dart';
import 'package:jari/app/modules/admin/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserManagementController());
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final padding = isTablet ? 32.0 : 24.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 14.0 : 12.0;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih, fontSize: inputFontSize),
            onChanged: controller.searchUsers,
            decoration: InputDecoration(
              hintText: 'Cari pengguna...',
              hintStyle: TextStyle(
                color: Warna.putih.withOpacity(0.5),
                fontSize: inputFontSize,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
                size: iconSize,
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 18 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.ungu, width: 2),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Add User Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, controller),
              icon: Icon(Icons.add, size: iconSize),
              label: Text(
                'Tambah Pengguna',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                foregroundColor: Warna.putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
              ),
            ),
          ),
          SizedBox(height: spacing + 8),

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
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.7),
                      fontSize: isTablet ? 16 : 14,
                    ),
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
      showDialog(
        context: context,
        builder: (context) =>
            DeleteUserDialog(user: user, controller: controller),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            ActivateUserDialog(user: user, controller: controller),
      );
    }
  }
}
