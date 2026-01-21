import 'package:benang_merah/app/core/values/app_icon_appbar.dart';
import 'package:flutter/material.dart';
import 'package:benang_merah/app/core/theme/app_colors.dart';

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
        padding: EdgeInsets.zero,
        height: double.infinity,
        color: Warna.abuAbu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Warna.hitamTransparan,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: SizedBox(
                height: 40,
                width: 25,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),

            ...List.generate(menuItems.length, (index) {
              return GestureDetector(
                onTap: () {
                  if (widget.onNavTap != null) {
                    widget.onNavTap!(index);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: menuItems[index],
                      ),
                      Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: widget.currentIndex == index
                              ? Warna.kuning
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
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
