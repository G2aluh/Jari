import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BaseDashboardLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<BottomNavigationBarItem> navItems;
  final int currentIndex;
  final Function(int) onNavTap;
  final Widget? fab;
  final String role;

  const BaseDashboardLayout({
    Key? key,
    required this.title,
    required this.body,
    required this.navItems,
    required this.currentIndex,
    required this.onNavTap,
    this.fab,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        //Search
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
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
              authController.logout();
              Get.offAllNamed('/login');
            },
            icon: Icon(IconlyLight.logout),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        
        backgroundColor: Warna.hitamBackground,
        selectedItemColor: Warna.putih,
        unselectedItemColor: Warna.putih.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onNavTap,
        items: navItems,
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
