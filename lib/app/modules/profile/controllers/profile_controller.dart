import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final _supabase = Supabase.instance.client;

  final rxUser = Rxn<Map<String, dynamic>>();
  final isLoading = true.obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final data = await _supabase
          .from('pengguna')
          .select()
          .eq('id', user.id)
          .single();

      // Add email from auth user if not in table
      final userData = Map<String, dynamic>.from(data);
      if (!userData.containsKey('email')) {
        userData['email'] = user.email;
      }

      rxUser.value = userData;
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final fileExt = image.path.split('.').last;
        await _uploadProfilePicture(bytes, fileExt);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadProfilePicture(Uint8List bytes, String fileExt) async {
    try {
      isUploading.value = true;
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Unique file path per user
      final fileName = '${user.id}/avatar.$fileExt';

      // Upload to Supabase Storage using uploadBinary (safer for cross-platform)
      await _supabase.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get Public URL
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);

      // Add timestamp to force refresh cache
      final urlWithTimestamp =
          '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      // Update User Record
      await _supabase
          .from('pengguna')
          .update({'url_profile': urlWithTimestamp})
          .eq('id', user.id);

      // Reload profile to update UI
      await loadProfile();

      Get.snackbar(
        'Sukses',
        'Foto profil berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar(
        'Error',
        'Gagal mengupload foto: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      Get.snackbar(
        'Sukses',
        'Password berhasil diubah',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah password: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
