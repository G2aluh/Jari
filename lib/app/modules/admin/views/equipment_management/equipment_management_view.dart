import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/equipment_controller.dart';
import 'package:benang_merah/app/modules/admin/models/alat_model.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/add_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/delete_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/edit_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/equipment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EquipmentManagementView extends StatelessWidget {
  const EquipmentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentController());

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            onChanged: controller.searchEquipments,
            decoration: InputDecoration(
              hintText: 'Cari alat...',
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

          // Add Equipment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context, controller),
              icon: Icon(Icons.add),
              label: Text('Tambah Alat'),
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

          // Equipment List
          Obx(() {
            if (controller.isLoading.value && controller.equipments.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(color: Warna.ungu),
                ),
              );
            }

            if (controller.filteredEquipments.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    'Tidak ada alat ditemukan',
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                ),
              );
            }

            return Column(
              children: controller.filteredEquipments.map((alat) {
                return EquipmentCard(
                  alat: alat,
                  onEdit: () => _showEditDialog(context, controller, alat),
                  onToggleStatus: () =>
                      _showToggleStatusDialog(context, controller, alat),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, EquipmentController controller) {
    showDialog(
      context: context,
      builder: (context) => AddEquipmentDialog(controller: controller),
    );
  }

  void _showEditDialog(
    BuildContext context,
    EquipmentController controller,
    Alat alat,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          EditEquipmentDialog(alat: alat, controller: controller),
    );
  }

  void _showToggleStatusDialog(
    BuildContext context,
    EquipmentController controller,
    Alat alat,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          DeleteEquipmentDialog(alat: alat, controller: controller),
    );
  }
}
