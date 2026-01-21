import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:benang_merah/app/widgets/side_drawer_menu.dart';
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
  final PreferredSizeWidget? customAppBar;

  const BaseDashboardLayout({
    Key? key,
    required this.title,
    required this.body,
    required this.navItems,
    required this.currentIndex,
    required this.onNavTap,
    this.fab,
    required this.role,
    this.customAppBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      drawer: role == 'admin'
          ? SizedBox(
              width: 100,
              child: SideDrawerMenu(
                onNavTap: onNavTap,
                currentIndex: currentIndex,
              ),
            )
          : null,
      backgroundColor: Warna.hitamBackground,
      appBar:
          customAppBar ??
          AppBar(
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
      bottomNavigationBar: role == 'admin'
          ? null
          : BottomNavigationBar(
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
