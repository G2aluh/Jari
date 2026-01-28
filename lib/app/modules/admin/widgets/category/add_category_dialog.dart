import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/category_controller.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final CategoryController controller;

  const AddCategoryDialog({super.key, required this.controller});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final deskripsiController = TextEditingController();
  IconData selectedIcon = Icons.category;
  bool isLoading = false;

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
    Icons.electrical_services,
    Icons.construction,
    Icons.handyman,
    Icons.plumbing,
    Icons.ac_unit,
    Icons.speaker,
    Icons.router,
    Icons.memory,
    Icons.smartphone,
    Icons.sports_esports,
  ];

  @override
  void dispose() {
    nameController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await widget.controller.addCategory(
      namaKategori: nameController.text.trim(),
      deskripsi: deskripsiController.text.trim().isNotEmpty
          ? deskripsiController.text.trim()
          : null,
      iconCode: selectedIcon.codePoint,
      iconFamily: selectedIcon.fontFamily ?? 'MaterialIcons',
      iconPackage: selectedIcon.fontPackage,
    );

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: Warna.putih.withOpacity(0.5)),
      errorStyle: TextStyle(color: Colors.red[300]),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.ungu),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Text('Tambah Kategori', style: TextStyle(color: Warna.putih)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Preview and Selection
              GestureDetector(
                onTap: () => _showIconSelectionDialog(context),
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

              // Nama Kategori
              TextFormField(
                controller: nameController,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration('Nama Kategori', Icons.category),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: deskripsiController,
                style: TextStyle(color: Warna.putih),
                maxLines: 2,
                decoration: _inputDecoration(
                  'Deskripsi (opsional)',
                  Icons.description,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
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
          onPressed: isLoading ? null : _handleAdd,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Warna.putih,
                  ),
                )
              : Text('Simpan', style: TextStyle(color: Warna.putih)),
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
        content: SizedBox(
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
