import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/category_controller.dart';
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
    final dialogWidth = isTablet ? 450.0 : 320.0;
    final titleSize = isTablet ? 22.0 : 18.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 24.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconPreviewSize = isTablet ? 50.0 : 40.0;
    final iconContainerPadding = isTablet ? 24.0 : 20.0;

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
                'Tambah Kategori',
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
                    // Icon Preview and Selection
                    GestureDetector(
                      onTap: () => _showIconSelectionDialog(context, isTablet),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(iconContainerPadding),
                            decoration: BoxDecoration(
                              color: Warna.ungu.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: Warna.ungu, width: 2),
                            ),
                            child: Icon(
                              selectedIcon,
                              size: iconPreviewSize,
                              color: Warna.ungu,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            'Ketuk untuk ubah ikon',
                            style: TextStyle(
                              color: Warna.putih.withOpacity(0.5),
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing + 8),

                    // Nama Kategori
                    TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      decoration: _inputDecoration(
                        'Nama Kategori',
                        Icons.category,
                        isTablet,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama kategori tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: spacing),

                    // Deskripsi
                    TextFormField(
                      controller: deskripsiController,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: inputFontSize,
                      ),
                      maxLines: 2,
                      decoration: _inputDecoration(
                        'Deskripsi (opsional)',
                        Icons.description,
                        isTablet,
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
                            'Simpan',
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

  void _showIconSelectionDialog(BuildContext context, bool isTablet) {
    final gridCols = isTablet ? 6 : 5;
    final gridSpacing = isTablet ? 14.0 : 10.0;
    final iconSize = isTablet ? 28.0 : 24.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Pilih Ikon',
          style: TextStyle(color: Warna.putih, fontSize: isTablet ? 20 : 16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCols,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
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
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                  ),
                  child: Icon(
                    availableIcons[index],
                    color: Warna.putih,
                    size: iconSize,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
