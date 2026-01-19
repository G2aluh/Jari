import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class RejectionDialog extends StatelessWidget {
  const RejectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Warna.abuAbu,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Penolakan",
            style: AppTextStyles.primaryText.copyWith(
              fontSize: 18,
              color: Warna.putih,
            ),
            textAlign: TextAlign.start,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Warna.putih),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Masukkan alasan penolakan",
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 8),
          TextField(
            style: TextStyle(color: Warna.putih),
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Warna.hitamBackground,

              hintText: "Contoh: Stok alat tidak mencukupi",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle rejection logic here
                  Navigator.pop(context);
                },
                child: Text("Tolak", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
