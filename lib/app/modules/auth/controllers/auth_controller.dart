import 'package:get/get.dart';

class AuthController extends GetxController {
  final _currentUserRole = ''.obs;
  final _isLoggedIn = false.obs;

  String get currentUserRole => _currentUserRole.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // Role constants
  static const String ADMIN = 'admin';
  static const String PETUGAS = 'petugas';
  static const String PEMINJAM = 'peminjam';

  // Mock login function - in real app, this would connect to backend
  Future<bool> login(String username, String password, String role) async {
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    // In a real app, validate credentials with backend
    // For now, we'll just accept any credentials and assign the selected role
    if (username.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
      _currentUserRole.value = role;
      _isLoggedIn.value = true;
      update();
      return true;
    }
    return false;
  }

  // Mock logout function
  void logout() {
    _currentUserRole.value = '';
    _isLoggedIn.value = false;
    update();
  }

  // Check if user has a specific role
  bool hasRole(String role) {
    return _currentUserRole.value == role;
  }
}
