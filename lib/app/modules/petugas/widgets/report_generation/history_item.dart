import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String type;

  const HistoryItem({
    super.key,
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Warna.putih.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Warna.abuAbu, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Warna.putih,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$type • $date",
                  style: TextStyle(
                    color: Warna.putih.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.download_done, color: Warna.ungu, size: 20),
        ],
      ),
    );
  }
}
