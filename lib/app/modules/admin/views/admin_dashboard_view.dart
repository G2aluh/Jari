import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/admin_dashboard_controller.dart';
import 'package:jari/app/modules/admin/widgets/admin_appbar.dart';
import 'package:jari/app/widgets/base_dashboard_layout.dart';
import 'package:jari/app/modules/admin/views/user_management/user_management_view.dart';
import 'package:jari/app/modules/admin/views/equipment_management/equipment_management_view.dart';
import 'package:jari/app/modules/admin/views/category_management/category_management_view.dart';
import 'package:jari/app/modules/admin/views/loan_management/loan_management_view.dart';
import 'package:jari/app/modules/admin/views/return_management/return_management_view.dart';
import 'package:jari/app/modules/admin/views/settings/settings_view.dart';
import 'package:jari/app/modules/admin/views/activity_log/activity_log_view.dart';
import 'package:jari/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _currentIndex = 0;

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return _buildDashboardPage();
      case 1:
        return const UserManagementView();
      case 2:
        return const EquipmentManagementView();
      case 3:
        return const CategoryManagementView();
      case 4:
        return LoanManagementView();
      case 5:
        return ReturnManagementView();
      case 6:
        return const ActivityLogView();
      case 7:
        return const SettingsView();
      case 8:
        return const ProfileView();
      default:
        return _buildDashboardPage();
    }
  }

  String _getTitleWidget(int index) {
    switch (index) {
      case 0:
        return 'Dashboard Admin';
      case 1:
        return 'Manajemen Pengguna';
      case 2:
        return 'Manajemen Alat';
      case 3:
        return 'Manajemen Kategori';
      case 4:
        return 'Manajemen Peminjaman';
      case 5:
        return 'Manajemen Pengembalian';
      case 6:
        return 'Log Aktivitas';
      case 7:
        return 'Pengaturan';
      case 8:
        return 'Profil Saya';
      default:
        return 'Dashboard Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDashboardLayout(
      title: _getTitleWidget(_currentIndex),
      customAppBar: AdminAppBar(title: _getTitleWidget(_currentIndex)),
      body: _getBodyWidget(_currentIndex),
      navItems: const [],
      currentIndex: _currentIndex,
      onNavTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      role: 'admin',
    );
  }

  Widget _buildDashboardPage() {
    final controller = Get.put(AdminDashboardController());
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final padding = isTablet ? 32.0 : 24.0;
    final cardPadding = isTablet ? 24.0 : 20.0;
    final titleSize = isTablet ? 22.0 : 18.0;
    final valueSize = isTablet ? 28.0 : 24.0;
    final labelSize = isTablet ? 16.0 : 14.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final iconPadding = isTablet ? 14.0 : 10.0;
    final navIconSize = isTablet ? 32.0 : 28.0;
    final navLabelSize = isTablet ? 14.0 : 12.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final gridColumns = isTablet ? 4 : 3;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCard(
            title: 'Total Transaksi',
            value: controller.totalTransaksi.value.toString(),
            icon: Icons.receipt_long,
            color: Colors.blue,
            cardPadding: cardPadding,
            valueSize: valueSize,
            labelSize: labelSize,
            iconSize: iconSize,
            iconPadding: iconPadding,
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Menunggu',
                  value: controller.menunggu.value.toString(),
                  icon: Icons.hourglass_empty,
                  color: Warna.kuning,
                  cardPadding: cardPadding,
                  valueSize: valueSize,
                  labelSize: labelSize,
                  iconSize: iconSize,
                  iconPadding: iconPadding,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Ditolak',
                  value: controller.ditolak.value.toString(),
                  icon: Icons.cancel,
                  color: Colors.red,
                  cardPadding: cardPadding,
                  valueSize: valueSize,
                  labelSize: labelSize,
                  iconSize: iconSize,
                  iconPadding: iconPadding,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Alat',
                  value: controller.totalAlat.value.toString(),
                  icon: Icons.inventory_2,
                  color: Warna.ungu,
                  cardPadding: cardPadding,
                  valueSize: valueSize,
                  labelSize: labelSize,
                  iconSize: iconSize,
                  iconPadding: iconPadding,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Kategori',
                  value: controller.totalKategori.value.toString(),
                  icon: Icons.category,
                  color: Colors.teal,
                  cardPadding: cardPadding,
                  valueSize: valueSize,
                  labelSize: labelSize,
                  iconSize: iconSize,
                  iconPadding: iconPadding,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 32 : 24),
          Text(
            'Navigasi Cepat',
            style: TextStyle(
              color: Warna.putih,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing),
          GridView.count(
            crossAxisCount: gridColumns,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: isTablet ? 16 : 12,
            crossAxisSpacing: isTablet ? 16 : 12,
            childAspectRatio: 1.0,
            children: [
              _buildQuickNavButton(
                icon: Icons.people,
                label: 'Pengguna',
                index: 1,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
              _buildQuickNavButton(
                icon: Icons.inventory_2,
                label: 'Alat',
                index: 2,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
              _buildQuickNavButton(
                icon: Icons.category,
                label: 'Kategori',
                index: 3,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
              _buildQuickNavButton(
                icon: Icons.assignment,
                label: 'Peminjaman',
                index: 4,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
              _buildQuickNavButton(
                icon: Icons.assignment_return,
                label: 'Pengembalian',
                index: 5,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
              _buildQuickNavButton(
                icon: Icons.history,
                label: 'Log',
                index: 6,
                iconSize: navIconSize,
                labelSize: navLabelSize,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double cardPadding,
    required double valueSize,
    required double labelSize,
    required double iconSize,
    required double iconPadding,
  }) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Warna.putih.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Warna.putih.withOpacity(0.7),
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNavButton({
    required IconData icon,
    required String label,
    required int index,
    required double iconSize,
    required double labelSize,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Warna.hitamTransparan,
        foregroundColor: Warna.putih,
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        elevation: 0,
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Warna.ungu),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: labelSize),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
