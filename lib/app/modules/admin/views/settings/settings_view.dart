import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());
  final TextEditingController _fineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    // Initial check
    if (controller.aturanDendaHarian.value != null) {
      _fineController.text = controller.aturanDendaHarian.value!.nilaiDenda
          .toString();
    }

    // Listen to changes in controller data to populate field
    _worker = ever(controller.aturanDendaHarian, (aturan) {
      if (aturan != null) {
        _fineController.text = aturan.nilaiDenda.toString();
      }
    });

    // Realtime subscription is handled in controller onInit
  }

  @override
  void dispose() {
    _worker?.dispose();
    _fineController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final value = num.tryParse(_fineController.text);
      if (value != null) {
        final success = await controller.updateDenda(value);
        if (success && mounted) {
          Get.snackbar(
            "Berhasil",
            "Pengaturan denda berhasil disimpan",
            backgroundColor: Warna.ungu,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            borderRadius: 10,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Warna.putih.withOpacity(0.1)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Warna.ungu.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.settings,
                          color: Warna.ungu,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Pengaturan Sistem",
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Denda Keterlambatan (Per Hari)",
                    style: TextStyle(
                      color: Warna.putih,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.aturanDendaHarian.value == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return TextFormField(
                      controller: _fineController,
                      style: TextStyle(color: Warna.putih),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Warna.hitamBackground,
                        prefixText: "Rp ",
                        prefixStyle: TextStyle(color: Warna.putih),
                        hintText: "Masukkan nominal denda",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Warna.putih.withOpacity(0.2),
                          ),
                        ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nominal denda tidak boleh kosong';
                        }
                        if (num.tryParse(value) == null) {
                          return 'Masukkan angka yang valid';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Warna.ungu,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Simpan Perubahan",
                                style: TextStyle(
                                  color: Warna.putih,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
