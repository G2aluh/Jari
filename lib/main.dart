import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:benang_merah/app/routes/app_pages.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(
    AuthController(),
    permanent: true,
  ); // Initialize AuthController globally
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.urbanistTextTheme()),
      title: 'Benang Merah',
      initialRoute: Routes.login,
      getPages: AppPages.pages,
    );
  }
}
