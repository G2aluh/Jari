import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/equipment_controller.dart';
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

  InputDecoration _inputDecoration(String label, IconData icon, bool isTablet) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(0.7),
        fontSize: isTablet ? 16 : 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Warna.putih.withOpacity(0.5),
        size: isTablet ? 24 : 20,
      ),
      errorStyle: TextStyle(
        color: Colors.red[300],
        fontSize: isTablet ? 14 : 12,
      ),
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
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 480.0 : 320.0;
    final titleSize = isTablet ? 22.0 : 18.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final imageSize = isTablet ? 130.0 : 100.0;
    final imageIconSize = isTablet ? 50.0 : 40.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Alat',
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: Warna.abuAbu,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                          border: Border.all(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 12 : 8,
                                ),
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
                                size: imageIconSize,
                              ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    TextButton.icon(
                      onPressed: _pickImage,
                      label: Text(
                        selectedImage != null ? "Ganti Gambar" : "Pilih Gambar",
                        style: TextStyle(
                          color: Warna.ungu,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      icon: Icon(
                        Icons.upload,
                        color: Warna.ungu,
                        size: isTablet ? 20 : 16,
                      ),
                    ),
                    SizedBox(height: spacing),

                    // Kode Alat
                    TextFormField(
                      controller: kodeController,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        'Kode Alat',
                        Icons.qr_code,
                        isTablet,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Kode alat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Nama Alat
                    TextFormField(
                      controller: namaController,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        'Nama Alat',
                        Icons.build,
                        isTablet,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama alat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Stok
                    TextFormField(
                      controller: stokController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        'Stok Total',
                        Icons.inventory,
                        isTablet,
                      ),
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
                    SizedBox(height: spacing),

                    // Kategori Dropdown
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: selectedKategoriId,
                        dropdownColor: Warna.abuAbu,
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: inputFontSize,
                        ),
                        decoration: _inputDecoration(
                          'Kategori',
                          Icons.category,
                          isTablet,
                        ),
                        items: widget.controller.categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat.id,
                            child: Text(
                              cat.namaKategori,
                              style: TextStyle(fontSize: inputFontSize),
                            ),
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
              SizedBox(height: spacing + 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 16,
                        vertical: isTablet ? 12 : 8,
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Warna.putih.withOpacity(0.7),
                        fontSize: buttonFontSize,
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.ungu,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                        vertical: isTablet ? 14 : 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleAdd,
                    child: isLoading
                        ? SizedBox(
                            width: isTablet ? 24 : 20,
                            height: isTablet ? 24 : 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Warna.putih,
                            ),
                          )
                        : Text(
                            'Tambah',
                            style: TextStyle(
                              color: Warna.putih,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
