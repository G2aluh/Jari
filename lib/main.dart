import 'package:benang_merah/app/routes/app_pages.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        textTheme: GoogleFonts.urbanistTextTheme(),
      ),
      title: 'Benang Merah',
      initialRoute: Routes.peminjamDashboard,
      getPages: AppPages.pages,
    );
  }
}