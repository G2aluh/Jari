import 'package:benang_merah/app/widgets/base_dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:benang_merah/app/modules/petugas/views/loan_verification/loan_verification_view.dart';
import 'package:benang_merah/app/modules/petugas/views/return_monitoring/return_monitoring_view.dart';
import 'package:benang_merah/app/modules/petugas/views/report_generation/report_generation_view.dart';

class PetugasDashboardView extends StatefulWidget {
  const PetugasDashboardView({super.key});

  @override
  State<PetugasDashboardView> createState() => _PetugasDashboardViewState();
}

class _PetugasDashboardViewState extends State<PetugasDashboardView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set Verifikasi as default (index 0 now corresponds to Verifikasi)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onNavTap(0);
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0: // Verifikasi
        return const LoanVerificationView();
      case 1: // Return Monitoring
        return const ReturnMonitoringView();
      case 2: // Reports
        return const ReportGenerationView();
      default:
        return const LoanVerificationView(); // Default to verification
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDashboardLayout(
      title: _getTitleByIndex(_currentIndex),
      body: _getBodyWidget(_currentIndex),
      navItems: [
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.tickSquare),
          label: 'Verifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.arrowDownSquare),
          label: 'Pengembalian',
        ),
        BottomNavigationBarItem(
          icon: Icon(IconlyLight.document),
          label: 'Laporan',
        ),
      ],
      currentIndex: _currentIndex,
      onNavTap: _onNavTap,
      role: 'petugas',
    );
  }

  String _getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return 'Verifikasi Peminjaman';
      case 1:
        return 'Monitor Pengembalian';
      case 2:
        return 'Laporan';
      default:
        return 'Verifikasi Peminjaman';
    }
  }
}
