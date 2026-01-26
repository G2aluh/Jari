import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/widgets/return/delete_return_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/return/edit_return_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/return/return_card.dart';
import 'package:flutter/material.dart';

class ReturnManagementView extends StatelessWidget {
  const ReturnManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for returns
    final List<Map<String, dynamic>> returns = [
      {
        'id': '#R-101',
        'borrower': 'John Doe',
        'items': [
          {'name': 'Mesin Jahit', 'qty': 1},
          {'name': 'Benang', 'qty': 5},
        ],
        'status': 'Menunggu',
        'date': '22 Jan 2026',
      },
      {
        'id': '#R-100',
        'borrower': 'Jane Smith',
        'items': [
          {'name': 'Obeng Set', 'qty': 1},
        ],
        'status': 'Selesai',
        'date': '21 Jan 2026',
        'fine': 0,
      },
      {
        'id': '#R-099',
        'borrower': 'Budi Santoso',
        'items': [
          {'name': 'Kamera Canon', 'qty': 1},
        ],
        'status': 'Selesai',
        'date': '20 Jan 2026',
        'fine': 0,
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
              hintText: 'Cari kode pengembalian...',
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

          SizedBox(height: 8),

          // Return List
          ...returns
              .map(
                (item) => ReturnCard(
                  item: item,
                  onEdit: () => _showEditDialog(context, item),
                  onDelete: () => _showDeleteDialog(context, item),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => EditReturnDialog(item: item),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => DeleteReturnDialog(item: item),
    );
  }
}
