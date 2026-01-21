import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/widgets/admin_appbar.dart';
import 'package:benang_merah/app/widgets/base_dashboard_layout.dart';
import 'package:benang_merah/app/modules/admin/views/user_management/user_management_view.dart';
import 'package:benang_merah/app/modules/admin/views/equipment_management/equipment_management_view.dart';
import 'package:benang_merah/app/modules/admin/views/category_management/category_management_view.dart';
import 'package:benang_merah/app/modules/admin/views/loan_management/loan_management_view.dart';
import 'package:benang_merah/app/modules/admin/views/return_management/return_management_view.dart';
import 'package:benang_merah/app/modules/admin/views/activity_log/activity_log_view.dart';
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
        return const LoanManagementView();
      case 5:
        return const ReturnManagementView();
      case 6:
        return const ActivityLogView();
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCard(
            title: 'Total Transaksi',
            value: '128',
            icon: Icons.receipt_long,
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Menunggu',
                  value: '12',
                  icon: Icons.hourglass_empty,
                  color: Warna.kuning,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Ditolak',
                  value: '5',
                  icon: Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Alat',
                  value: '350',
                  icon: Icons.inventory_2,
                  color: Warna.ungu,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Kategori',
                  value: '8',
                  icon: Icons.category,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Navigasi Cepat',
            style: TextStyle(
              color: Warna.putih,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
            children: [
              _buildQuickNavButton(
                icon: Icons.people,
                label: 'Pengguna',
                index: 1,
              ),
              _buildQuickNavButton(
                icon: Icons.inventory_2,
                label: 'Alat',
                index: 2,
              ),
              _buildQuickNavButton(
                icon: Icons.category,
                label: 'Kategori',
                index: 3,
              ),
              _buildQuickNavButton(
                icon: Icons.assignment,
                label: 'Peminjaman',
                index: 4,
              ),
              _buildQuickNavButton(
                icon: Icons.assignment_return,
                label: 'Pengembalian',
                index: 5,
              ),
              _buildQuickNavButton(icon: Icons.history, label: 'Log', index: 6),
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
  }) {
    return Container(
      padding: EdgeInsets.all(20),
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: 24,
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
              fontSize: 14,
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
          Icon(icon, size: 28, color: Warna.ungu),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
