import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:benang_merah/app/routes/app_pages.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

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
