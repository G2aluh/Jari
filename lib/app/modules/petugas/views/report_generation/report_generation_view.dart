import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/petugas/views/report_generation/controller/report_controller.dart';

class ReportGenerationView extends StatelessWidget {
  const ReportGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportGenerationController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= Responsive.mobileMaxWidth;
        final hPadding = isTablet ? 40.0 : 24.0;
        final vPadding = isTablet ? 32.0 : 16.0;
        final maxWidth = isTablet ? 650.0 : double.infinity;
        final spacing = isTablet ? 24.0 : 16.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding,
                vertical: vPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =====================
                  // SELECT JENIS LAPORAN
                  // =====================
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedType.value,
                      dropdownColor: Warna.hitamBackground,
                      style: TextStyle(
                        color: Warna.putih,
                        fontSize: isTablet ? 18 : 14,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Jenis laporan',
                        icon: IconlyLight.filter,
                        isTablet: isTablet,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'harian',
                          child: Text(
                            'Laporan Harian',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: isTablet ? 18 : 14,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'mingguan',
                          child: Text(
                            'Laporan Mingguan',
                            style: TextStyle(fontSize: isTablet ? 18 : 14),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'bulanan',
                          child: Text(
                            'Laporan Bulanan',
                            style: TextStyle(fontSize: isTablet ? 18 : 14),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        controller.selectedType.value = value!;
                        controller.applyPreset();
                        controller.previewDataCount();
                      },
                    );
                  }),
                  SizedBox(height: spacing),

                  // =====================
                  // FORM TANGGAL
                  // =====================
                  Obx(() {
                    return Column(
                      children: [
                        _DateField(
                          label: 'Tanggal Awal',
                          date: controller.startDate.value,
                          isTablet: isTablet,
                          onPick: (date) {
                            controller.startDate.value = date;
                            controller.previewDataCount();
                          },
                        ),
                        if (controller.selectedType.value != 'harian') ...[
                          SizedBox(height: isTablet ? 20 : 12),
                          _DateField(
                            label: 'Tanggal Akhir',
                            date: controller.endDate.value,
                            isTablet: isTablet,
                            onPick: (date) {
                              controller.endDate.value = date;
                              controller.previewDataCount();
                            },
                          ),
                        ],
                      ],
                    );
                  }),

                  SizedBox(height: spacing),

                  // =====================
                  // PREVIEW JUMLAH DATA
                  // =====================
                  Obx(() {
                    if (controller.previewCount.value == 0) {
                      return Text(
                        'Tidak ada data pada periode ini',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.6),
                          fontSize: isTablet ? 16 : 13,
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
                            fontSize: isTablet ? 15 : 13,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 6),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 14 : 12),
                            decoration: BoxDecoration(
                              color: Warna.hitamTransparan,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 16 : 12,
                              ),
                              border: Border.all(
                                color: Warna.putih.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              '${controller.previewCount.value}',
                              style: TextStyle(
                                color: Warna.putih,
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: isTablet ? 40 : 24),

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
                          ? SizedBox(
                              height: isTablet ? 24 : 18,
                              width: isTablet ? 24 : 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Warna.putih,
                              ),
                            )
                          : Icon(
                              Icons.print,
                              color: Warna.putih,
                              size: isTablet ? 24 : 20,
                            ),
                      label: Text(
                        controller.isGenerating.value
                            ? 'Mencetak...'
                            : 'Cetak Laporan',
                        style: TextStyle(
                          color: Warna.putih,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 24 : 18,
                        ),
                        backgroundColor: Warna.abuAbu.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                          side: BorderSide(color: Warna.putih.withOpacity(0.5)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =====================
  // SHARED INPUT DECORATION
  // =====================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isTablet,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Warna.putih.withOpacity(0.5),
        fontSize: isTablet ? 18 : 14,
      ),
      prefixIcon: Icon(
        icon,
        color: Warna.putih.withOpacity(0.5),
        size: isTablet ? 24 : 18,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: isTablet ? 20 : 12,
      ),
      filled: true,
      fillColor: Warna.hitamTransparan,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        borderSide: const BorderSide(color: Warna.ungu, width: 2),
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
  final bool isTablet;
  final ValueChanged<DateTime> onPick;

  const _DateField({
    required this.label,
    required this.date,
    required this.isTablet,
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
            labelStyle: TextStyle(
              color: Warna.putih.withOpacity(0.7),
              fontSize: isTablet ? 18 : 14,
            ),
            filled: true,
            fillColor: Warna.hitamTransparan,
            contentPadding: EdgeInsets.symmetric(
              horizontal: isTablet ? 20 : 16,
              vertical: isTablet ? 20 : 12,
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              size: isTablet ? 22 : 16,
              color: Warna.putih,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
          ),
          style: TextStyle(color: Warna.putih, fontSize: isTablet ? 18 : 14),
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
