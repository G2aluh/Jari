import 'dart:typed_data';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/equipment_controller.dart';
import 'package:jari/app/modules/admin/models/alat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditEquipmentDialog extends StatefulWidget {
  final Alat alat;
  final EquipmentController controller;

  const EditEquipmentDialog({
    super.key,
    required this.alat,
    required this.controller,
  });

  @override
  State<EditEquipmentDialog> createState() => _EditEquipmentDialogState();
}

class _EditEquipmentDialogState extends State<EditEquipmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController kodeController;
  late TextEditingController namaController;
  late TextEditingController stokTotalController;
  late TextEditingController stokTersediaController;

  late String? selectedKategoriId;
  XFile? selectedImage;
  Uint8List? selectedImageBytes;
  bool isLoading = false;
  bool isDeleting = false;

  late String originalKode;
  late String originalNama;
  late String originalStokTotal;
  late String originalStokTersedia;
  late String? originalKategoriId;

  @override
  void initState() {
    super.initState();
    kodeController = TextEditingController(text: widget.alat.kodeAlat);
    namaController = TextEditingController(text: widget.alat.namaAlat);
    stokTotalController = TextEditingController(
      text: widget.alat.stokTotal.toString(),
    );
    stokTersediaController = TextEditingController(
      text: widget.alat.stokTersedia.toString(),
    );
    selectedKategoriId = widget.alat.kategoriId;

    originalKode = widget.alat.kodeAlat;
    originalNama = widget.alat.namaAlat;
    originalStokTotal = widget.alat.stokTotal.toString();
    originalStokTersedia = widget.alat.stokTersedia.toString();
    originalKategoriId = widget.alat.kategoriId;

    kodeController.addListener(_onChanged);
    namaController.addListener(_onChanged);
    stokTotalController.addListener(_onChanged);
    stokTersediaController.addListener(_onChanged);
  }

  @override
  void dispose() {
    kodeController.dispose();
    namaController.dispose();
    stokTotalController.dispose();
    stokTersediaController.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get hasChanges {
    return kodeController.text != originalKode ||
        namaController.text != originalNama ||
        stokTotalController.text != originalStokTotal ||
        stokTersediaController.text != originalStokTersedia ||
        selectedKategoriId != originalKategoriId ||
        selectedImage != null;
  }

  Future<void> _pickImage() async {
    final image = await widget.controller.pickImage();
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedImage = image;
        selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await widget.controller.updateEquipment(
      id: widget.alat.id,
      kodeAlat: kodeController.text.trim(),
      namaAlat: namaController.text.trim(),
      kategoriId: selectedKategoriId,
      stokTotal: int.tryParse(stokTotalController.text) ?? 0,
      stokTersedia: int.tryParse(stokTersediaController.text) ?? 0,
      aktif: widget.alat.aktif,
      existingImageUrl: widget.alat.alatUrl,
      newImageFile: selectedImage,
    );

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  void _showDeleteConfirmation(bool isTablet) {
    final titleSize = isTablet ? 20.0 : 16.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final smallSize = isTablet ? 14.0 : 12.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: isTablet ? 28 : 24,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              'Hapus Permanen',
              style: TextStyle(color: Colors.red, fontSize: titleSize),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus alat ini secara permanen?',
              style: TextStyle(color: Warna.putih, fontSize: bodySize),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.build,
                    color: Warna.putih.withOpacity(0.7),
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alat.namaAlat,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: bodySize,
                          ),
                        ),
                        Text(
                          widget.alat.kodeAlat,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: smallSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              '*Tindakan ini tidak dapat dibatalkan!',
              style: TextStyle(color: Colors.orange, fontSize: smallSize),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: bodySize,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 12 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _handleDelete();
            },
            child: Text(
              'Hapus Permanen',
              style: TextStyle(color: Warna.putih, fontSize: bodySize),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete() async {
    setState(() => isDeleting = true);

    try {
      await widget.controller.hardDeleteEquipment(
        widget.alat.id,
        imageUrl: widget.alat.alatUrl,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => isDeleting = false);
      }
    }
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    bool readOnly = false,
    required bool isTablet,
  }) {
    final opacity = readOnly ? 0.3 : 0.5;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(readOnly ? 0.5 : 0.7),
        fontSize: isTablet ? 16 : 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Warna.putih.withOpacity(opacity),
        size: isTablet ? 24 : 20,
      ),
      errorStyle: TextStyle(
        color: Colors.red[300],
        fontSize: isTablet ? 14 : 12,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Warna.putih.withOpacity(opacity)),
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

  Widget _buildImagePreview(bool isTablet) {
    final iconSize = isTablet ? 50.0 : 40.0;

    if (selectedImageBytes != null) {
      return Image.memory(selectedImageBytes!, fit: BoxFit.cover);
    } else if (widget.alat.alatUrl != null && widget.alat.alatUrl!.isNotEmpty) {
      return Image.network(
        widget.alat.alatUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported,
          color: Warna.putih.withOpacity(0.5),
          size: iconSize,
        ),
      );
    } else {
      return Icon(
        Icons.add_a_photo,
        color: Warna.putih.withOpacity(0.5),
        size: iconSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = hasChanges && !isLoading && !isDeleting;
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet
        ? 520.0
        : MediaQuery.of(context).size.width * 0.9;
    final titleSize = isTablet ? 24.0 : 20.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final buttonPadding = isTablet ? 18.0 : 14.0;
    final contentPadding = isTablet ? 28.0 : 20.0;
    final imageSize = isTablet ? 130.0 : 100.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.fromLTRB(
                contentPadding,
                spacing,
                isTablet ? 12 : 8,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Alat',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.7),
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  contentPadding,
                  spacing,
                  contentPadding,
                  0,
                ),
                child: Form(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 12 : 8,
                            ),
                            child: _buildImagePreview(isTablet),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      TextButton.icon(
                        onPressed: _pickImage,
                        label: Text(
                          "Ganti Gambar",
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
                          isTablet: isTablet,
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
                          isTablet: isTablet,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama alat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing),

                      // Stok Total
                      TextFormField(
                        controller: stokTotalController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: inputFontSize,
                        ),
                        decoration: _inputDecoration(
                          'Stok Total',
                          Icons.inventory,
                          isTablet: isTablet,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stok total tidak boleh kosong';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Stok harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing),

                      // Stok Tersedia
                      TextFormField(
                        controller: stokTersediaController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: inputFontSize,
                        ),
                        decoration: _inputDecoration(
                          'Stok Tersedia',
                          Icons.check_circle,
                          isTablet: isTablet,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stok tersedia tidak boleh kosong';
                          }
                          final stokTersedia = int.tryParse(value);
                          if (stokTersedia == null) {
                            return 'Stok harus berupa angka';
                          }
                          final stokTotal =
                              int.tryParse(stokTotalController.text) ?? 0;
                          if (stokTersedia > stokTotal) {
                            return 'Tidak boleh melebihi stok total ($stokTotal)';
                          }
                          if (stokTersedia < 0) {
                            return 'Stok tidak boleh negatif';
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
                            isTablet: isTablet,
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
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Row(
                children: [
                  // Hapus Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      onPressed: (isLoading || isDeleting)
                          ? null
                          : () => _showDeleteConfirmation(isTablet),
                      child: isDeleting
                          ? SizedBox(
                              width: isTablet ? 24 : 20,
                              height: isTablet ? 24 : 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              'Hapus',
                              style: TextStyle(fontSize: buttonFontSize),
                            ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  // Simpan Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSave ? Warna.ungu : Warna.abuAbu,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 12 : 8,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                      ),
                      onPressed: canSave ? _handleSave : null,
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
                              'Simpan',
                              style: TextStyle(
                                color: canSave
                                    ? Warna.putih
                                    : Warna.putih.withOpacity(0.5),
                                fontSize: buttonFontSize,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
