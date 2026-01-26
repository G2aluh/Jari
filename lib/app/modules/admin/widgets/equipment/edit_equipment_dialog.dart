import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/kategori/views/kategori_list_view.dart';
import 'package:flutter/material.dart';

class EditEquipmentDialog extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditEquipmentDialog({super.key, required this.item});

  @override
  State<EditEquipmentDialog> createState() => _EditEquipmentDialogState();
}

class _EditEquipmentDialogState extends State<EditEquipmentDialog> {
  late TextEditingController nameController;
  late TextEditingController stockController;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name']);
    stockController = TextEditingController(
      text: widget.item['stock'].toString(),
    );
    try {
      selectedCategory = kategoriList
          .firstWhere((e) => e.nama == widget.item['category'])
          .nama;
    } catch (e) {
      selectedCategory = null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    stockController.dispose();
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
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Preview
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Warna.abuAbu,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.item['gambar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      color: Warna.putih,
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {},
                label: Text("Ubah Gambar", style: TextStyle(color: Warna.ungu)),
                icon: Icon(Icons.edit, color: Warna.ungu, size: 16),
              ),
              SizedBox(height: 16),

              TextField(
                controller: nameController,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Nama Alat',
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
                controller: stockController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Stok Alat',
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
                value: selectedCategory,
                dropdownColor: Warna.abuAbu,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Kategori Alat',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
                items: kategoriList.map((category) {
                  return DropdownMenuItem(
                    value: category.nama,
                    child: Text(category.nama),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
            ],
          ),
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
