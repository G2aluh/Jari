import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditLoanDialog extends StatefulWidget {
  final Map<String, dynamic> loan;

  const EditLoanDialog({super.key, required this.loan});

  @override
  State<EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<EditLoanDialog> {
  late String selectedStatus;
  late TextEditingController dateController;
  late TextEditingController returnDateController;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.loan['status'];
    dateController = TextEditingController(text: widget.loan['date']);
    returnDateController = TextEditingController(
      text: widget.loan['returnDate'],
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    returnDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = widget.loan['items'];

    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text(
        'Edit Peminjaman ${widget.loan['id']}',
        style: TextStyle(color: Warna.putih),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Alat",
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
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
                setState(() {
                  selectedStatus = value!;
                });
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
    );
  }
}
