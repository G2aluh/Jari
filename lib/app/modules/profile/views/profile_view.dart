import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Obx(() {
      final user = controller.rxUser.value;
      final role = user?['role'] as String?;
      final isPeminjam = role == 'peminjam';

      return Scaffold(
        backgroundColor: Warna.hitamBackground,
        appBar: isPeminjam
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Warna.putih),
                  onPressed: () => Get.back(),
                ),
                title: Text(
                  'Profil Saya',
                  style: TextStyle(color: Warna.putih),
                ),
                centerTitle: true,
              )
            : null,
        body: Builder(
          builder: (context) {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: Warna.ungu),
              );
            }

            if (user == null) {
              return Center(
                child: Text(
                  'Gagal memuat profil',
                  style: TextStyle(color: Warna.putih),
                ),
              );
            }

            final urlProfile = user['url_profile'] as String?;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isPeminjam) const SizedBox(height: 40),

                  // Unified Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Warna.hitamTransparan,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Warna.putih.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: controller.isUploading.value
                              ? null
                              : () => controller.pickAndUploadImage(),
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Warna.ungu.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Warna.ungu,
                                    width: 2,
                                  ),
                                  image: urlProfile != null
                                      ? DecorationImage(
                                          image: NetworkImage(urlProfile),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: urlProfile == null
                                    ? Center(
                                        child: Icon(
                                          IconlyBold.profile,
                                          size: 50,
                                          color: Warna.ungu,
                                        ),
                                      )
                                    : null,
                              ),
                              if (controller.isUploading.value)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Warna.putih,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Warna.ungu,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Warna.hitamBackground,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Warna.putih,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        Text(
                          user['nama'] ?? 'Tanpa Nama',
                          style: TextStyle(
                            color: Warna.putih,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Warna.kuning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Warna.kuning.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            (user['role'] as String? ?? '-').toUpperCase(),
                            style: TextStyle(
                              color: Warna.kuning,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Divider(color: Warna.putih.withOpacity(0.1)),
                        const SizedBox(height: 24),

                        // Email Info
                        _buildInfoRow('Email', user['email'] ?? '-'),

                        const SizedBox(height: 32),

                        // Change Password Button (Inside Container)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _showChangePasswordDialog(context, controller),
                            icon: Icon(
                              IconlyBold.lock,
                              color: Warna.putih,
                              size: 16,
                            ),
                            label: Text(
                              'Ubah Password',
                              style: TextStyle(
                                color: Warna.putih,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              side: BorderSide(color: Warna.abuAbu),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Warna.putih.withOpacity(0.6), fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Warna.putih,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(
    BuildContext context,
    ProfileController controller,
  ) {
    final passController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Warna.hitamBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Warna.putih.withOpacity(0.1)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Password',
                  style: TextStyle(
                    color: Warna.putih,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // New Password
                TextFormField(
                  controller: passController,
                  obscureText: true,
                  style: TextStyle(color: Warna.putih),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  style: TextStyle(color: Warna.putih),
                  validator: (value) {
                    if (value != passController.text) {
                      return 'Password tidak sama';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Warna.putih.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Warna.ungu),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Warna.putih),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            await controller.updatePassword(
                              passController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.ungu,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Warna.putih),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
