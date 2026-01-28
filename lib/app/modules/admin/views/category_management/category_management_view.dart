import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/category_controller.dart';
import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';
import 'package:benang_merah/app/modules/admin/widgets/category/add_category_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/category/category_card.dart';
import 'package:benang_merah/app/modules/admin/widgets/category/delete_category_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/category/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            onChanged: controller.searchCategories,
            decoration: InputDecoration(
              hintText: 'Cari kategori...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Add Category Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, controller),
              icon: Icon(Icons.add),
              label: Text('Tambah Kategori'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                foregroundColor: Warna.putih,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          SizedBox(height: 24),

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
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
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
