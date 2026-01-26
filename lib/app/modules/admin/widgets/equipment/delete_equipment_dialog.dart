import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DeleteEquipmentDialog extends StatelessWidget {
  final Map<String, dynamic> item;

  const DeleteEquipmentDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text('Hapus Alat', style: TextStyle(color: Warna.putih)),
      content: Text(
        'Apakah Anda yakin ingin menghapus alat "${item['name']}"?',
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
    );
  }
}
