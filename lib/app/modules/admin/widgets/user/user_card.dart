import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/models/pengguna_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Pengguna user;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: user.aktif ? 1.0 : 0.5,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: user.aktif
                ? Warna.putih.withOpacity(0.2)
                : Colors.red.withOpacity(0.3),
          ),
          color: Warna.hitamTransparan,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: user.aktif
                    ? Warna.ungu.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                child: Text(
                  user.nama.isNotEmpty ? user.nama[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: user.aktif ? Warna.ungu : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with status indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.nama,
                            style: TextStyle(
                              color: user.aktif
                                  ? Warna.putih
                                  : Warna.putih.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              decoration: user.aktif
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        if (!user.aktif)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Nonaktif',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Email
                    Text(
                      user.email,
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    SizedBox(height: 6),

                    // Role badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getRoleColor(user.role).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        user.roleDisplay,
                        style: TextStyle(
                          color: _getRoleColor(user.role),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),

              // Action buttons
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
                    onTap: onToggleStatus,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      ),
                      // Merah jika aktif (untuk nonaktifkan), putih jika nonaktif (untuk aktifkan)
                      child: Icon(
                        Icons.stop_circle,
                        color: user.aktif ? Colors.red : Warna.putih,
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
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.orange;
      case 'petugas':
        return Colors.blue;
      case 'peminjam':
        return Colors.green;
      default:
        return Warna.putih;
    }
  }
}
