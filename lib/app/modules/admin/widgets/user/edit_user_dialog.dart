import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditUserDialog extends StatefulWidget {
  final Map<String, String> user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController nameController;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['name']);
    selectedRole = widget.user['role']!;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text('Edit Pengguna', style: TextStyle(color: Warna.putih)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              labelText: 'Nama Lengkap',
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
          DropdownButtonFormField<String>(
            value: selectedRole,
            dropdownColor: Warna.abuAbu,
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              labelText: 'Role',
              labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
            items: ['Admin', 'Petugas', 'Peminjam']
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
          ),
        ],
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
