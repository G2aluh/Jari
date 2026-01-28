import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/category_controller.dart';
import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';
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
    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Row(
        children: [
          Text('Hapus Kategori', style: TextStyle(color: Warna.putih)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah Anda yakin ingin menghapus kategori ini?',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Warna.ungu.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_getIcon(), color: Warna.ungu, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.namaKategori,
                        style: TextStyle(
                          color: Warna.putih,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.category.deskripsi != null &&
                          widget.category.deskripsi!.isNotEmpty)
                        Text(
                          widget.category.deskripsi!,
                          style: TextStyle(
                            color: Warna.putih.withOpacity(0.6),
                            fontSize: 12,
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
          SizedBox(height: 12),
          Text(
            '*Kategori akan dihapus permanen dan tidak dapat dikembalikan',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12,
            ),
          ),
        ],
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
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isLoading ? null : _handleDelete,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Warna.putih,
                  ),
                )
              : Text('Hapus', style: TextStyle(color: Warna.putih)),
        ),
      ],
    );
  }
}
