import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/category_controller.dart';
import 'package:jari/app/modules/admin/models/kategori_alat_model.dart';
import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatefulWidget {
  final KategoriAlat category;
  final CategoryController controller;

  const DeleteCategoryDialog({
    super.key,
    required this.category,
    required this.controller,
  });

  @override
  State<DeleteCategoryDialog> createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<DeleteCategoryDialog> {
  bool isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => isLoading = true);

    final success = await widget.controller.deleteCategory(widget.category.id);

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  IconData _getIcon() {
    if (widget.category.iconCode > 0) {
      return IconData(
        widget.category.iconCode,
        fontFamily: widget.category.iconFamily,
        fontPackage: widget.category.iconPackage,
      );
    }
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final dialogWidth = isTablet ? 450.0 : 320.0;
    final titleSize = isTablet ? 20.0 : 16.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final smallSize = isTablet ? 14.0 : 12.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 20.0 : 16.0;
    final contentPadding = isTablet ? 28.0 : 24.0;
    final iconSize = isTablet ? 24.0 : 20.0;

    return Dialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      child: Container(
        width: dialogWidth,
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hapus Kategori',
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Text(
              'Apakah Anda yakin ingin menghapus kategori ini?',
              style: TextStyle(
                color: Warna.putih.withOpacity(0.7),
                fontSize: bodySize,
              ),
            ),
            SizedBox(height: spacing),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Warna.hitamTransparan,
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 8),
                    decoration: BoxDecoration(
                      color: Warna.ungu.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                    child: Icon(_getIcon(), color: Warna.ungu, size: iconSize),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.namaKategori,
                          style: TextStyle(
                            color: Warna.putih,
                            fontWeight: FontWeight.bold,
                            fontSize: bodySize,
                          ),
                        ),
                        if (widget.category.deskripsi != null &&
                            widget.category.deskripsi!.isNotEmpty)
                          Text(
                            widget.category.deskripsi!,
                            style: TextStyle(
                              color: Warna.putih.withOpacity(0.6),
                              fontSize: smallSize,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              '*Kategori akan dihapus permanen dan tidak dapat dikembalikan',
              style: TextStyle(color: Colors.orange, fontSize: smallSize),
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
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                      vertical: isTablet ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleDelete,
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
                          'Hapus',
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
    );
  }
}
