import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditReturnDialog extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditReturnDialog({super.key, required this.item});

  @override
  State<EditReturnDialog> createState() => _EditReturnDialogState();
}

class _EditReturnDialogState extends State<EditReturnDialog> {
  late String selectedStatus;
  late TextEditingController dateController;
  late TextEditingController fineController;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.item['status'];
    dateController = TextEditingController(text: widget.item['date']);
    fineController = TextEditingController(
      text: (widget.item['fine'] ?? 0).toString(),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    fineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = widget.item['items'];

    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text(
        'Edit Pengembalian ${widget.item['id']}',
        style: TextStyle(color: Warna.putih),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Alat Kembali",
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
    );
  }
}
