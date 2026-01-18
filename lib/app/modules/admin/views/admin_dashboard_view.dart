import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/widgets/base_dashboard_layout.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _currentIndex = 0;

  void _navigateToPage(int index) {
    switch (index) {
      case 1: // User Management
        Get.toNamed(Routes.userManagement);
        break;
      case 2: // Equipment Management
        Get.toNamed(Routes.equipmentManagement);
        break;
      case 3: // Category Management
        Get.toNamed(Routes.categoryManagement);
        break;
      case 4: // Activity Log
        Get.toNamed(Routes.activityLog);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDashboardLayout(
      title: 'Dashboard Admin',
      body: _buildDashboardPage(),
      navItems: [
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.profile),
          label: 'Pengguna',
        ),
        BottomNavigationBarItem(icon: Icon(IconlyLight.bag2), label: 'Alat'),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.category),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(icon: Icon(IconlyLight.chart), label: 'Log'),
      ],
      currentIndex: _currentIndex,
      onNavTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index != 0) {
          // Only navigate if not on dashboard
          _navigateToPage(index);
        }
      },
      role: 'admin',
    );
  }

  Widget _buildDashboardPage() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.admin_panel_settings, size: 80, color: Warna.ungu),
          SizedBox(height: 24),
          Text(
            'Dashboard Admin',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Warna.putih,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Kelola sistem secara keseluruhan',
            style: TextStyle(fontSize: 16, color: Warna.putih.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
