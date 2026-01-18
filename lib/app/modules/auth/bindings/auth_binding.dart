import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is already initialized globally in main()
    // Skip binding to avoid duplicate instances
  }
}
