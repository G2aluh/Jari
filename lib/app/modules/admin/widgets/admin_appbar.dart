import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return AppBar(
      elevation: 0,
      backgroundColor: Warna.hitamBackground,
      foregroundColor: Warna.putih,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: ActionChip(
        label: Text(title),
        labelStyle: TextStyle(color: Warna.putih),
        shape: StadiumBorder(),
        side: BorderSide(width: 0),
        backgroundColor: Warna.hitamTransparan,
        onPressed: () {},
      ),
      centerTitle: true,
      actions: [
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            authController.showLogoutConfirmation();
          },
          icon: Icon(IconlyLight.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
