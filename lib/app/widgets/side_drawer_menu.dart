import 'package:flutter/material.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/values/app_icon_appbar.dart';

class SideDrawerMenu extends StatefulWidget {
  final Function(int)? onNavTap;
  final int? currentIndex;

  const SideDrawerMenu({Key? key, this.onNavTap, this.currentIndex})
    : super(key: key);

  @override
  State<SideDrawerMenu> createState() => _SideDrawerMenuState();
}

class _SideDrawerMenuState extends State<SideDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        height: double.infinity,
        color: Warna.abuAbu,
        child: Column(
          children: [
            // =====================
            // HEADER
            // =====================
            Container(
              height: 100,
              width: double.infinity,
              color: Warna.hitamTransparan,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),

            // =====================
            // MENU ITEMS
            // =====================
            ...List.generate(menuItems.length, (index) {
              final isActive = widget.currentIndex == index;

              return GestureDetector(
                onTap: () {
                  widget.onNavTap?.call(index);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isActive ? Warna.ungu : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: isActive ? Warna.putih : Warna.hitamBackground,
                        size: 24,
                      ),
                      child: menuItems[index],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
