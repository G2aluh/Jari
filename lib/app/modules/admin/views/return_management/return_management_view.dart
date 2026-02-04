import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/admin/controllers/pengembalian_controller.dart';
import 'package:jari/app/modules/admin/models/pengembalian_model.dart';
import 'package:jari/app/modules/admin/widgets/return/add_return_dialog.dart';
import 'package:jari/app/modules/admin/widgets/return/edit_return_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnManagementView extends StatelessWidget {
  ReturnManagementView({super.key});

  final PengembalianController controller = Get.put(PengembalianController());

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    // Responsive sizing
    final padding = isTablet ? 32.0 : 24.0;
    final inputFontSize = isTablet ? 16.0 : 14.0;
    final buttonFontSize = isTablet ? 16.0 : 14.0;
    final buttonPadding = isTablet ? 18.0 : 16.0;
    final iconSize = isTablet ? 24.0 : 20.0;
    final cardIconSize = isTablet ? 28.0 : 24.0;
    final cardIconPadding = isTablet ? 16.0 : 12.0;
    final cardTitleSize = isTablet ? 18.0 : 16.0;
    final cardSubtitleSize = isTablet ? 15.0 : 13.0;
    final cardSmallSize = isTablet ? 14.0 : 12.0;
    final emptyIconSize = isTablet ? 80.0 : 64.0;
    final emptyTextSize = isTablet ? 18.0 : 16.0;
    final spacing = isTablet ? 20.0 : 16.0;
    final borderRadius = isTablet ? 14.0 : 12.0;
    final cardPadding = isTablet ? 20.0 : 18.0;

    return Container(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Column(
        children: [
          // Search Input
          TextField(
            onChanged: controller.searchPengembalian,
            style: TextStyle(color: Warna.putih, fontSize: inputFontSize),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(
                color: Warna.putih.withOpacity(0.5),
                fontSize: inputFontSize,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
                size: iconSize,
              ),
              filled: true,
              fillColor: Warna.hitamTransparan,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 18 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.putih.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Warna.ungu, width: 2),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.dialog(AddReturnDialog(controller: controller)),
              icon: Icon(Icons.add, color: Colors.white, size: iconSize),
              label: Text(
                'Tambah Pengembalian',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: buttonFontSize,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),

          // List Pengembalian
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Warna.ungu),
                );
              }

              if (controller.pengembalianList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_edu,
                        size: emptyIconSize,
                        color: Warna.putih.withOpacity(0.2),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        'Belum ada data pengembalian',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: emptyTextSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.pengembalianList.length,
                itemBuilder: (context, index) {
                  final pengembalian = controller.pengembalianList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                    padding: EdgeInsets.symmetric(
                      horizontal: cardPadding,
                      vertical: isTablet ? 16 : 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      color: Warna.hitamTransparan,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 12 : 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(cardIconPadding),
                            decoration: BoxDecoration(
                              color: Warna.ungu.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Icon(
                              Icons.assignment_return,
                              color: Warna.ungu,
                              size: cardIconSize,
                            ),
                          ),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pengembalian.kodePeminjaman,
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.bold,
                                    fontSize: cardTitleSize,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 4 : 2),
                                Text(
                                  pengembalian.namaPeminjam,
                                  style: TextStyle(
                                    color: Warna.putih.withOpacity(0.7),
                                    fontSize: cardSubtitleSize,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: isTablet ? 14 : 12,
                                      color: Warna.putih.withOpacity(0.5),
                                    ),
                                    SizedBox(width: isTablet ? 6 : 4),
                                    Text(
                                      pengembalian.tanggalKembaliFormatted,
                                      style: TextStyle(
                                        color: Warna.putih.withOpacity(0.5),
                                        fontSize: cardSmallSize,
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 12 : 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 8 : 6,
                                        vertical: isTablet ? 4 : 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (pengembalian.status ==
                                                        StatusPengembalian
                                                            .selesai
                                                    ? Colors.green
                                                    : Colors.orange)
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        pengembalian.status.displayName,
                                        style: TextStyle(
                                          color:
                                              pengembalian.status ==
                                                  StatusPengembalian.selesai
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: isTablet ? 12 : 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (pengembalian.terlambatHari > 0) ...[
                                  SizedBox(height: isTablet ? 6 : 4),
                                  Text(
                                    'Terlambat ${pengembalian.terlambatHari} Hari',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isTablet ? 13 : 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: isTablet ? 16 : 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => Get.dialog(
                                  EditReturnDialog(
                                    pengembalian: pengembalian,
                                    controller: controller,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(isTablet ? 10 : 6),
                                  decoration: BoxDecoration(
                                    color: Warna.abuAbu,
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 8 : 6,
                                    ),
                                    border: Border.all(
                                      color: Warna.putih.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Warna.putih,
                                    size: isTablet ? 20 : 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              GestureDetector(
                                onTap: () => _confirmDelete(
                                  context,
                                  pengembalian.id,
                                  isTablet,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(isTablet ? 10 : 6),
                                  decoration: BoxDecoration(
                                    color: Warna.abuAbu,
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 8 : 6,
                                    ),
                                    border: Border.all(
                                      color: Warna.putih.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Warna.putih,
                                    size: isTablet ? 20 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, bool isTablet) {
    final titleSize = isTablet ? 20.0 : 18.0;
    final bodySize = isTablet ? 16.0 : 14.0;
    final buttonSize = isTablet ? 16.0 : 14.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Hapus Pengembalian?',
          style: TextStyle(color: Warna.putih, fontSize: titleSize),
        ),
        content: Text(
          'Data pengembalian akan dihapus permanen.',
          style: TextStyle(
            color: Warna.putih.withOpacity(0.7),
            fontSize: bodySize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Warna.putih, fontSize: buttonSize),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deletePengembalian(id);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.red, fontSize: buttonSize),
            ),
          ),
        ],
      ),
    );
  }
}
