import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final KategoriAlat category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getIcon() {
    // Convert icon code to IconData
    if (category.iconCode > 0) {
      return IconData(
        category.iconCode,
        fontFamily: category.iconFamily,
        fontPackage: category.iconPackage,
      );
    }
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.ungu.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: Warna.ungu, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.namaKategori,
                    style: TextStyle(
                      color: Warna.putih,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (category.deskripsi != null &&
                      category.deskripsi!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        category.deskripsi!,
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Warna.abuAbu,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Icon(Icons.edit, color: Warna.putih, size: 16),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Warna.abuAbu,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Icon(Icons.delete, color: Colors.red, size: 16),
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
