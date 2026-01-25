import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
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
                (item) => Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 12,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Warna.ungu.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.assignment_return,
                            color: Warna.ungu,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['id'],
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    item['date'],
                                    style: TextStyle(
                                      color: Warna.putih.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        item['status'],
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: TextStyle(
                                        color: _getStatusColor(item['status']),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (item['fine'] != null && item['fine'] > 0) ...[
                                SizedBox(height: 4),
                                Text(
                                  'Denda: Rp ${item['fine']}', // Basic formatting
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => _showEditDialog(context, item),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Warna.abuAbu,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Warna.putih,
                                  size: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showDeleteDialog(context, item),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Warna.abuAbu,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Warna.putih,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    String selectedStatus = item['status'];
    final TextEditingController dateController = TextEditingController(
      text: item['date'],
    );
    final TextEditingController fineController = TextEditingController(
      text: (item['fine'] ?? 0).toString(),
    );
    final List<Map<String, dynamic>> items = item['items'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Edit Pengembalian ${item['id']}',
          style: TextStyle(color: Warna.putih),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar Alat Kembali",
                style: TextStyle(
                  color: Warna.putih,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Warna.abuAbu,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: Column(
                  children: items
                      .map(
                        (itm) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                itm['name'],
                                style: TextStyle(color: Warna.putih),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Warna.hitamBackground,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "x${itm['qty']}",
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                dropdownColor: Warna.abuAbu,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Status Pengembalian',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
                items: ['Menunggu', 'Selesai']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: dateController,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Tanggal Kembali',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: fineController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Denda Keterlambatan',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                  prefixText: 'Rp ',
                  prefixStyle: TextStyle(color: Warna.putih),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Warna.putih.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Warna.ungu,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Handle edit logic here
              Navigator.pop(context);
            },
            child: Text(
              'Simpan',
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Hapus Pengembalian', style: TextStyle(color: Warna.putih)),
        content: Text(
          'Apakah Anda yakin ingin menghapus data pengembalian "${item['id']}"?',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Warna.putih.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Handle delete logic here
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Warna.kuning;
      case 'Selesai':
        return Colors.green; // Changed to green for success/completion
      default:
        return Colors.grey;
    }
  }
}
