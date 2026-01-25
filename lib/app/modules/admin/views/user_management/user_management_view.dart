import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for users
    final List<Map<String, String>> users = [
      {'name': 'Admin Utama', 'role': 'Admin', 'email': 'admin@example.com'},
      {'name': 'Budi Santoso', 'role': 'Petugas', 'email': 'budi@example.com'},
      {'name': 'Siti Aminah', 'role': 'Peminjam', 'email': 'siti@example.com'},
      {'name': 'Rudi Hartono', 'role': 'Peminjam', 'email': 'rudi@example.com'},
      {'name': 'Dewi Lestari', 'role': 'Petugas', 'email': 'dewi@example.com'},
    ];

    return Container(
      padding: EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: ListView(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari pengguna...',
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

          // Add User Button
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Tambah Pengguna'),
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

          // User List
          ...users
              .map(
                (user) => Container(
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
                        CircleAvatar(
                          backgroundColor: Warna.ungu.withOpacity(0.2),
                          child: Text(
                            user['name']![0],
                            style: TextStyle(
                              color: Warna.ungu,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name']!,
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                user['email']!,
                                style: TextStyle(
                                  color: Warna.putih.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Warna.hitamBackground.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Warna.putih.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  user['role']!,
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontSize: 12,
                                  ),
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
                              onTap: () => _showEditDialog(context, user),
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
                              onTap: () => _showDeleteDialog(context, user),
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

  void _showAddDialog(BuildContext context) {
    String selectedRole = 'Peminjam'; // Default role
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Tambah Pengguna',
          style: TextStyle(color: Warna.putih),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                dropdownColor: Warna.abuAbu,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  labelText: 'Role',
                  labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Warna.ungu),
                  ),
                ),
                items: ['Admin', 'Petugas', 'Peminjam']
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedRole = value!;
                },
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
              // Handle add logic here
              Navigator.pop(context);
            },
            child: Text(
              'Tambah',
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> user) {
    String selectedRole = user['role']!;
    final TextEditingController nameController = TextEditingController(
      text: user['name'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Edit Pengguna', style: TextStyle(color: Warna.putih)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: Warna.putih),
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Warna.ungu),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              dropdownColor: Warna.abuAbu,
              style: TextStyle(color: Warna.putih),
              decoration: InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Warna.putih.withOpacity(0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Warna.ungu),
                ),
              ),
              items: ['Admin', 'Petugas', 'Peminjam']
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),
              onChanged: (value) {
                selectedRole = value!;
              },
            ),
          ],
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
              style: TextStyle(color: Warna.putih, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text('Hapus Pengguna', style: TextStyle(color: Warna.putih)),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengguna "${user['name']}"?',
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
