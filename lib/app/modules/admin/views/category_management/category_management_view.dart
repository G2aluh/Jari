import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CategoryManagementView extends StatefulWidget {
  const CategoryManagementView({super.key});

  @override
  State<CategoryManagementView> createState() => _CategoryManagementViewState();
}

class _CategoryManagementViewState extends State<CategoryManagementView> {
  // Dummy data for categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Peralatan Jahit', 'icon': Icons.cut},
    {'name': 'Peralatan Bengkel', 'icon': Icons.build},
    {'name': 'Elektronik', 'icon': Icons.devices},
    {'name': 'Multimedia', 'icon': Icons.camera_alt},
    {'name': 'Kebersihan', 'icon': Icons.cleaning_services},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: ListView(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
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
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCategoryDialog(context),
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
              ],
            ),
          ),
          SizedBox(height: 24),

          // Category List
          ...categories
              .map(
                (category) => Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 12,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    color: Warna.hitamTransparan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Warna.ungu.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category['icon'],
                            color: Warna.ungu,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['name'],
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                              onTap: () => _showCategoryDialog(
                                context,
                                category: category,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Warna.abuAbu,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Warna.putih,
                                  size: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showDeleteDialog(context, category),
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Warna.abuAbu,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Warna.putih,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context, {
    Map<String, dynamic>? category,
  }) {
    final bool isEdit = category != null;
    final TextEditingController nameController = TextEditingController(
      text: isEdit ? category['name'] : '',
    );
    IconData selectedIcon = isEdit ? category['icon'] : Icons.category;

    // List of available icons for selection
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
      Icons.delete,
      
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Warna.hitamBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Warna.putih.withOpacity(0.2)),
          ),
          title: Text(
            isEdit ? 'Edit Kategori' : 'Tambah Kategori',
            style: TextStyle(color: Warna.putih),
          ),
          
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Preview and Selection
                GestureDetector(
                  onTap: () {
                    // Show icon selection dialog/grid
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Warna.hitamBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
                        ),
                        title: Text(
                          'Pilih Ikon',
                          style: TextStyle(color: Warna.putih),
                        ),
                        content: Container(
                          width: double.maxFinite,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
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
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Warna.putih.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    availableIcons[index],
                                    color: Warna.putih,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Warna.ungu.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Warna.ungu, width: 2),
                        ),
                        child: Icon(selectedIcon, size: 40, color: Warna.ungu),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ketuk untuk ubah ikon',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  style: TextStyle(color: Warna.putih),
                  decoration: InputDecoration(
                    labelText: 'Nama Kategori',
                    labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
              ],
            ),
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
                backgroundColor: Warna.ungu,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Handle save logic here
                Navigator.pop(context);
              },
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Warna.putih,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Hapus Kategori', style: TextStyle(color: Warna.putih)),
        content: Text(
          'Apakah Anda yakin ingin menghapus kategori "${category['name']}"?',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
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
            onPressed: () {
              // Handle delete logic here
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
