import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/add_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/delete_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/edit_equipment_dialog.dart';
import 'package:benang_merah/app/modules/admin/widgets/equipment/equipment_card.dart';
import 'package:flutter/material.dart';

class EquipmentManagementView extends StatelessWidget {
  const EquipmentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for equipment
    final List<Map<String, dynamic>> equipment = [
      {
        'name': 'Mesin Jahit Butterfly',
        'stock': 5,
        'category': 'Menjahit',
        'status': 'Tersedia',
        'gambar': 'assets/images/benang.png',
      },
      {
        'name': 'Obeng Set Tekiro',
        'stock': 12,
        'category': 'Elektronik',
        'status': 'Tersedia',
        'gambar': 'assets/images/gunting.png',
      },
      {
        'name': 'Gerinda Tangan Bosch',
        'stock': 3,
        'category': 'Elektronik',
        'status': 'Terbatas',
        'gambar': 'assets/images/setrika.png',
      },
      {
        'name': 'Laptop Asus Rog',
        'stock': 0,
        'category': 'Elektronik',
        'status': 'Habis',
        'gambar': 'assets/images/mesinJahit.png',
      },
      {
        'name': 'Kamera Canon EOS',
        'stock': 2,
        'category': 'Desain',
        'status': 'Tersedia',
        'gambar': 'assets/images/mesinObras.png',
      },
    ];

    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: ListView(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
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
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
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
              ],
            ),
          ),
          SizedBox(height: 24),

          // Equipment List
          ...equipment
              .map(
                (item) => EquipmentCard(
                  item: item,
                  onEdit: () => _showEditDialog(context, item),
                  onDelete: () => _showDeleteDialog(context, item),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => EditEquipmentDialog(item: item),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddEquipmentDialog(),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => DeleteEquipmentDialog(item: item),
    );
  }
}
