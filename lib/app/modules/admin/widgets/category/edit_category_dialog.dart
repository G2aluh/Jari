import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {
  final Map<String, dynamic> category;

  const EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController nameController;
  late IconData selectedIcon;

  // List of available icons for selection
  final List<IconData> availableIcons = [
    Icons.cut,
    Icons.build,
    Icons.devices,
    Icons.camera_alt,
    Icons.cleaning_services,
    Icons.inventory_2,
    Icons.chair,
    Icons.weekend,
    Icons.kitchen,
    Icons.computer,
    Icons.print,
    Icons.wifi,
    Icons.security,
    Icons.local_shipping,
    Icons.delete,
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category['name']);
    selectedIcon = widget.category['icon'];
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
      title: Text('Edit Kategori', style: TextStyle(color: Warna.putih)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Preview and Selection
            GestureDetector(
              onTap: () {
                _showIconSelectionDialog(context);
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Warna.ungu.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Warna.ungu, width: 2),
                    ),
                    child: Icon(selectedIcon, size: 40, color: Warna.ungu),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ketuk untuk ubah ikon',
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: nameController,
              style: TextStyle(color: Warna.putih),
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
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
            // Handle save logic here
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

  void _showIconSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Pilih Ikon', style: TextStyle(color: Warna.putih)),
        content: Container(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: availableIcons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIcon = availableIcons[index];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedIcon == availableIcons[index]
                        ? Warna.ungu
                        : Warna.abuAbu,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: Icon(availableIcons[index], color: Warna.putih),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
