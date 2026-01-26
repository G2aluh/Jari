import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/widgets/loan/delete_loan_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/loan/edit_loan_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/loan/loan_card.dart';
import 'package:flutter/material.dart';

class LoanManagementView extends StatelessWidget {
  const LoanManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for loans
    final List<Map<String, dynamic>> loans = [
      {
        'id': '#1023',
        'borrower': 'John Doe',
        'items': [
          {'name': 'Mesin Jahit', 'qty': 1},
          {'name': 'Benang', 'qty': 5},
        ],
        'status': 'Menunggu',
        'date': '21 Jan 2026',
        'returnDate': '28 Jan 2026',
      },
      {
        'id': '#1022',
        'borrower': 'Jane Smith',
        'items': [
          {'name': 'Obeng Set', 'qty': 1},
        ],
        'status': 'Disetujui',
        'date': '20 Jan 2026',
        'returnDate': '27 Jan 2026',
      },
      {
        'id': '#1021',
        'borrower': 'Ahmad Dahlan',
        'items': [
          {'name': 'Laptop Asus Rog', 'qty': 1},
          {'name': 'Mouse Logitech', 'qty': 1},
        ],
        'status': 'Ditolak',
        'date': '19 Jan 2026',
        'returnDate': '26 Jan 2026',
      },
      {
        'id': '#1020',
        'borrower': 'Siti Nurhaliza',
        'items': [
          {'name': 'Kamera Canon', 'qty': 1},
        ],
        'status': 'Selesai',
        'date': '18 Jan 2026',
        'returnDate': '25 Jan 2026',
      },
    ];

    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: ListView(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Use similar "Add" button placeholder if needed for consistency,
          // though "Add Loan" might be less common for Admin.
          // But user asked for "mirip", so keeping the layout consistent.
          // Leaving it blank or creating a dummy button?
          // Usually Admin views follow the pattern. Let's add it but maybe for "Manual Loan".
          // Or just omit if not requested. But the structure "search -> space -> list" is good.
          // I will omit the "Add" button as typically Peminjaman starts from User.
          // If user insists on *exactly* similar, I'd add it.
          // For now, I'll stick to the list.

          // Actually, let's keep the spacing consistent.
          SizedBox(height: 8),

          // Loan List
          ...loans
              .map(
                (loan) => LoanCard(
                  loan: loan,
                  onEdit: () => _showEditDialog(context, loan),
                  onDelete: () => _showDeleteDialog(context, loan),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> loan) {
    showDialog(
      context: context,
      builder: (context) => EditLoanDialog(loan: loan),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> loan) {
    showDialog(
      context: context,
      builder: (context) => DeleteLoanDialog(loan: loan),
    );
  }
}
