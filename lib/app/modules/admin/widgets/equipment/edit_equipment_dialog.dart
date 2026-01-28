import 'dart:typed_data';
import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/equipment_controller.dart';
import 'package:benang_merah/app/modules/admin/models/alat_model.dart';
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

  // Original values for change detection
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

    // Store originals
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Permanen', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus alat ini secara permanen?',
              style: TextStyle(color: Warna.putih),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.build, color: Warna.putih.withOpacity(0.7)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alat.namaAlat,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.alat.kodeAlat,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              '⚠️ Tindakan ini tidak dapat dibatalkan!',
              style: TextStyle(color: Colors.orange, fontSize: 12),
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
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _handleDelete();
            },
            child: Text('Hapus Permanen', style: TextStyle(color: Warna.putih)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete() async {
    setState(() => isDeleting = true);

    // Hard delete - hapus permanen dari database dan storage
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
  }) {
    final opacity = readOnly ? 0.3 : 0.5;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Warna.putih.withOpacity(readOnly ? 0.5 : 0.7),
      ),
      prefixIcon: Icon(icon, color: Warna.putih.withOpacity(opacity)),
      errorStyle: TextStyle(color: Colors.red[300]),
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

  Widget _buildImagePreview() {
    if (selectedImageBytes != null) {
      return Image.memory(selectedImageBytes!, fit: BoxFit.cover);
    } else if (widget.alat.alatUrl != null && widget.alat.alatUrl!.isNotEmpty) {
      return Image.network(
        widget.alat.alatUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported,
          color: Warna.putih.withOpacity(0.5),
        ),
      );
    } else {
      return Icon(
        Icons.add_a_photo,
        color: Warna.putih.withOpacity(0.5),
        size: 40,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = hasChanges && !isLoading && !isDeleting;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Alat',
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Warna.putih.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                            border: Border.all(
                              color: Warna.putih.withOpacity(0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImagePreview(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _pickImage,
                        label: Text(
                          "Ganti Gambar",
                          style: TextStyle(color: Warna.ungu),
                        ),
                        icon: Icon(Icons.upload, color: Warna.ungu, size: 16),
                      ),
                      SizedBox(height: 16),

                      // Kode Alat
                      TextFormField(
                        controller: kodeController,
                        style: TextStyle(color: Warna.putih),
                        decoration: _inputDecoration(
                          'Kode Alat',
                          Icons.qr_code,
                        ),
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

                      // Stok Total
                      TextFormField(
                        controller: stokTotalController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Warna.putih),
                        decoration: _inputDecoration(
                          'Stok Total',
                          Icons.inventory,
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
                      SizedBox(height: 16),

                      // Stok Tersedia
                      TextFormField(
                        controller: stokTersediaController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Warna.putih),
                        decoration: _inputDecoration(
                          'Stok Tersedia',
                          Icons.check_circle,
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
                      SizedBox(height: 16),

                      // Kategori Dropdown
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: selectedKategoriId,
                          dropdownColor: Warna.abuAbu,
                          style: TextStyle(color: Warna.putih),
                          decoration: _inputDecoration(
                            'Kategori',
                            Icons.category,
                          ),
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
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // Hapus Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2),
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: (isLoading || isDeleting)
                          ? null
                          : _showDeleteConfirmation,
                      child: isDeleting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : Text('Hapus'),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Simpan Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSave ? Warna.ungu : Warna.abuAbu,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: canSave ? _handleSave : null,
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
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
