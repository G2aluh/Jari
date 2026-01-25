import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/kategori/views/kategori_list_view.dart';
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
                (item) => Container(
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Warna.abuAbu,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Warna.putih.withOpacity(0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item['gambar'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Warna.putih,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item['category'],
                                style: TextStyle(
                                  color: Warna.putih.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Stok: ${item['stock']}',
                                style: TextStyle(
                                  color: _getStockColor(item['stock']),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
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
                              onTap: () => _showEditDialog(context, item),
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
                              onTap: () => _showDeleteDialog(context, item),
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController nameController = TextEditingController(
      text: item['name'],
    );
    final TextEditingController stockController = TextEditingController(
      text: item['stock'].toString(),
    );
    String? selectedCategory;
    try {
      selectedCategory = kategoriList
          .firstWhere((e) => e.nama == item['category'])
          .nama;
    } catch (e) {
      selectedCategory = null;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Warna.hitamBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Warna.putih.withOpacity(0.2)),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image Preview
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['gambar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: Warna.putih,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text(
                        "Ubah Gambar",
                        style: TextStyle(color: Warna.ungu),
                      ),
                      icon: Icon(Icons.edit, color: Warna.ungu, size: 16),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Nama Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
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
                    SizedBox(height: 16),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Stok Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
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
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: Warna.abuAbu,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Kategori Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Warna.ungu),
                        ),
                      ),
                      items: kategoriList.map((category) {
                        return DropdownMenuItem(
                          value: category.nama,
                          child: Text(category.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ],
                ),
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
                  // Handle edit logic here
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
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Warna.hitamBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Warna.putih.withOpacity(0.2)),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image Selection Placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Warna.putih.withOpacity(0.5),
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text(
                        "Pilih Gambar",
                        style: TextStyle(color: Warna.ungu),
                      ),
                      icon: Icon(Icons.upload, color: Warna.ungu, size: 16),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Nama Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
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
                    SizedBox(height: 16),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Stok Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
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
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      dropdownColor: Warna.abuAbu,
                      style: TextStyle(color: Warna.putih),
                      decoration: InputDecoration(
                        labelText: 'Kategori Alat',
                        labelStyle: TextStyle(
                          color: Warna.putih.withOpacity(0.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Warna.ungu),
                        ),
                      ),
                      items: kategoriList.map((category) {
                        return DropdownMenuItem(
                          value: category.nama,
                          child: Text(category.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ],
                ),
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
                  // Handle add logic here
                  Navigator.pop(context);
                },
                child: Text(
                  'Tambah',
                  style: TextStyle(
                    color: Warna.putih,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Hapus Alat', style: TextStyle(color: Warna.putih)),
        content: Text(
          'Apakah Anda yakin ingin menghapus alat "${item['name']}"?',
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

  Color _getStockColor(int stock) {
    if (stock == 0) {
      return Colors.red;
    } else if (stock < 5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
