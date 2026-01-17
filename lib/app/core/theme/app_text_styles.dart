import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle primaryText = GoogleFonts.urbanistTextTheme().headlineMedium!.copyWith(
   color: Warna.putih,
    fontSize: 24,
  );

  static TextStyle barangTerbaikText = GoogleFonts.urbanistTextTheme().titleLarge!.copyWith(
   fontWeight: FontWeight.bold,
   fontSize: 18,
  );

  static TextStyle namaBarangText = GoogleFonts.urbanistTextTheme().titleMedium!.copyWith(
   fontWeight: FontWeight.bold,
   fontSize: 16,
  );

  static TextStyle stokText = GoogleFonts.urbanistTextTheme().titleMedium!.copyWith(
   fontWeight: FontWeight.bold,
   fontSize: 12,
   color: Warna.putih,
  );

  static TextStyle produkBaruText = GoogleFonts.urbanistTextTheme().titleMedium!.copyWith(
   fontSize: 12,
  );
}