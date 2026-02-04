import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/category_controller.dart';
import 'package:jari/app/modules/admin/models/kategori_alat_model.dart';
import 'package:jari/app/modules/admin/widgets/category/add_category_dialog.dart';
import 'package:jari/app/modules/admin/widgets/category/category_card.dart';
import 'package:jari/app/modules/admin/widgets/category/delete_category_dialog.dart';
import 'package:jari/app/modules/admin/widgets/category/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final padding = isTablet ? 32.0 : 24.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 14.0 : 12.0;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih, fontSize: inputFontSize),
            onChanged: controller.searchCategories,
            decoration: InputDecoration(
              hintText: 'Cari kategori...',
              hintStyle: TextStyle(
                color: Warna.putih.withOpacity(0.5),
                fontSize: inputFontSize,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
                size: iconSize,
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 18 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.ungu, width: 2),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Add Category Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, controller),
              icon: Icon(Icons.add, size: iconSize),
              label: Text(
                'Tambah Kategori',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                foregroundColor: Warna.putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
              ),
            ),
          ),
          SizedBox(height: spacing + 8),

          // Category List
          Obx(() {
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(color: Warna.ungu),
                ),
              );
            }

            if (controller.filteredCategories.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    'Tidak ada kategori ditemukan',
                    style: TextStyle(
                      color: Warna.putih.withOpacity(0.7),
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: controller.filteredCategories.map((category) {
                return CategoryCard(
                  category: category,
                  onEdit: () => _showEditDialog(context, controller, category),
                  onDelete: () =>
                      _showDeleteDialog(context, controller, category),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, CategoryController controller) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(controller: controller),
    );
  }

  void _showEditDialog(
    BuildContext context,
    CategoryController controller,
    KategoriAlat category,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          EditCategoryDialog(category: category, controller: controller),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    CategoryController controller,
    KategoriAlat category,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteCategoryDialog(category: category, controller: controller),
    );
  }
}
