import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
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
                (loan) => Container(
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
                            Icons.assignment,
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
                                loan['id'],
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
                                    loan['date'],
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
                                        loan['status'],
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      loan['status'],
                                      style: TextStyle(
                                        color: _getStatusColor(loan['status']),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => _showEditDialog(context, loan),
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
                              onTap: () => _showDeleteDialog(context, loan),
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> loan) {
    String selectedStatus = loan['status'];
    final TextEditingController dateController = TextEditingController(
      text: loan['date'],
    );
    final TextEditingController returnDateController = TextEditingController(
      text: loan['returnDate'],
    );
    final List<Map<String, dynamic>> items = loan['items'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Edit Peminjaman ${loan['id']}',
          style: TextStyle(color: Warna.putih),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar Alat",
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
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['name'],
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
                                  "x${item['qty']}",
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
                  labelText: 'Status Peminjaman',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
                items: ['Menunggu', 'Disetujui', 'Ditolak']
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
                  labelText: 'Tanggal Pinjam',
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
                controller: returnDateController,
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

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> loan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Hapus Peminjaman', style: TextStyle(color: Warna.putih)),
        content: Text(
          'Apakah Anda yakin ingin menghapus data peminjaman "${loan['id']}"?',
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
      case 'Disetujui':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      case 'Selesai':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
