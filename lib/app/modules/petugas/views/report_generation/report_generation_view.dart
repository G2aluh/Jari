import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/petugas/views/report_generation/controller/report_controller.dart';

class ReportGenerationView extends StatelessWidget {
  const ReportGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportGenerationController());

    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // =====================
          // SELECT JENIS LAPORAN
          // =====================
          Obx(() {
            return DropdownButtonFormField<String>(
              value: controller.selectedType.value,
              dropdownColor: Warna.hitamBackground,
              style: const TextStyle(color: Warna.putih),
              decoration: _inputDecoration(
                hint: 'Jenis laporan',
                icon: IconlyLight.filter,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'harian',
                  child: Text(
                    'Laporan Harian',
                    style: TextStyle(fontFamily: 'Urbanist'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'mingguan',
                  child: Text('Laporan Mingguan'),
                ),
                DropdownMenuItem(
                  value: 'bulanan',
                  child: Text('Laporan Bulanan'),
                ),
              ],
              onChanged: (value) {
                controller.selectedType.value = value!;
                controller.applyPreset(); // ✅ preset otomatis
                controller.previewDataCount(); // ✅ preview jumlah data
              },
            );
          }),
          const SizedBox(height: 16),

          // =====================
          // FORM TANGGAL (VERTIKAL)
          // =====================
          Obx(() {
            return Column(
              children: [
                _DateField(
                  label: 'Tanggal Awal',
                  date: controller.startDate.value,
                  onPick: (date) {
                    controller.startDate.value = date;
                    controller.previewDataCount();
                  },
                ),
                if (controller.selectedType.value != 'harian') ...[
                  const SizedBox(height: 12),
                  _DateField(
                    label: 'Tanggal Akhir',
                    date: controller.endDate.value,
                    onPick: (date) {
                      controller.endDate.value = date;
                      controller.previewDataCount();
                    },
                  ),
                ],
              ],
            );
          }),

          const SizedBox(height: 16),

          // =====================
          // PREVIEW JUMLAH DATA
          // =====================
          Obx(() {
            if (controller.previewCount.value == 0) {
              return Text(
                'Tidak ada data pada periode ini',
                style: TextStyle(
                  color: Warna.putih.withOpacity(0.6),
                  fontSize: 13,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Data',
                  style: TextStyle(
                    color: Warna.putih.withOpacity(0.7),
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Warna.hitamTransparan,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                    ),
                    child: Text(
                      '${controller.previewCount.value}',
                      style: const TextStyle(color: Warna.putih, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          // =====================
          // BUTTON CETAK
          // =====================
          Obx(() {
            final canPrint =
                controller.previewCount.value > 0 &&
                !controller.isGenerating.value;

            return ElevatedButton.icon(
              onPressed: canPrint ? controller.generateReport : null,
              icon: controller.isGenerating.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Warna.putih,
                      ),
                    )
                  : const Icon(Icons.print, color: Warna.putih),
              label: Text(
                controller.isGenerating.value ? 'Mencetak...' : 'Cetak Laporan',
                style: TextStyle(color: Warna.putih),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Warna.abuAbu.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Warna.putih.withOpacity(0.5)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // =====================
  // SHARED INPUT DECORATION
  // =====================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
      prefixIcon: Icon(icon, color: Warna.putih.withOpacity(0.5), size: 18),
      filled: true,
      fillColor: Warna.hitamTransparan,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Warna.ungu),
      ),
    );
  }
}

// =====================
// DATE FIELD (TAP TO PICK)
// =====================
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onPick;

  const _DateField({
    required this.label,
    required this.date,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDate: date ?? DateTime.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Warna.putih.withOpacity(0.7)),
            filled: true,
            fillColor: Warna.hitamTransparan,
            suffixIcon: const Icon(
              Icons.calendar_today,
              size: 16,
              color: Warna.putih,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: const TextStyle(color: Warna.putih),
          controller: TextEditingController(
            text: date == null
                ? ''
                : '${date!.day}/${date!.month}/${date!.year}',
          ),
        ),
      ),
    );
  }
}
