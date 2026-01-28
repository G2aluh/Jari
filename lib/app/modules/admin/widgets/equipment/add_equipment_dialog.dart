import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/equipment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddEquipmentDialog extends StatefulWidget {
  final EquipmentController controller;

  const AddEquipmentDialog({super.key, required this.controller});

  @override
  State<AddEquipmentDialog> createState() => _AddEquipmentDialogState();
}

class _AddEquipmentDialogState extends State<AddEquipmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final kodeController = TextEditingController();
  final namaController = TextEditingController();
  final stokController = TextEditingController();

  String? selectedKategoriId;
  XFile? selectedImage;
  bool isLoading = false;

  @override
  void dispose() {
    kodeController.dispose();
    namaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await widget.controller.pickImage();
    if (image != null) {
      setState(() => selectedImage = image);
    }
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await widget.controller.addEquipment(
      kodeAlat: kodeController.text.trim(),
      namaAlat: namaController.text.trim(),
      kategoriId: selectedKategoriId,
      stokTotal: int.tryParse(stokController.text) ?? 0,
      imageFile: selectedImage,
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
      title: Text('Tambah Alat', style: TextStyle(color: Warna.putih)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Warna.abuAbu,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FutureBuilder<dynamic>(
                            future: selectedImage!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Warna.putih,
                                ),
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.add_a_photo,
                          color: Warna.putih.withOpacity(0.5),
                          size: 40,
                        ),
                ),
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: _pickImage,
                label: Text(
                  selectedImage != null ? "Ganti Gambar" : "Pilih Gambar",
                  style: TextStyle(color: Warna.ungu),
                ),
                icon: Icon(Icons.upload, color: Warna.ungu, size: 16),
              ),
              SizedBox(height: 16),

              // Kode Alat
              TextFormField(
                controller: kodeController,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration('Kode Alat', Icons.qr_code),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode alat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Nama Alat
              TextFormField(
                controller: namaController,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration('Nama Alat', Icons.build),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama alat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Stok
              TextFormField(
                controller: stokController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Warna.putih),
                decoration: _inputDecoration('Stok Total', Icons.inventory),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Kategori Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedKategoriId,
                  dropdownColor: Warna.abuAbu,
                  style: TextStyle(color: Warna.putih),
                  decoration: _inputDecoration('Kategori', Icons.category),
                  items: widget.controller.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.namaKategori),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedKategoriId = value);
                  },
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
              : Text('Tambah', style: TextStyle(color: Warna.putih)),
        ),
      ],
    );
  }
}
