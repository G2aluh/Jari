import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, String> user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

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
                    style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Warna.hitamBackground.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Text(
                      user['role']!,
                      style: TextStyle(color: Warna.putih, fontSize: 12),
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
                    child: Icon(Icons.delete, color: Warna.putih, size: 16),
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
