import 'package:jari/app/core/theme/app_colors.dart';
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
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: Column(
        children: [
          // Search Input
          TextField(
            onChanged: controller.searchPengembalian,
            style: TextStyle(color: Warna.putih),
            decoration: InputDecoration(
              hintText: 'Cari kode peminjaman...',
              hintStyle: TextStyle(color: Warna.putih.withOpacity(0.5)),
              prefixIcon: Icon(
                Icons.search,
                color: Warna.putih.withOpacity(0.5),
              ),
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
                borderSide: BorderSide(color: Warna.ungu),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Add Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.dialog(AddReturnDialog(controller: controller)),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Pengembalian',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Warna.ungu,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

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
                        size: 64,
                        color: Warna.putih.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data pengembalian',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 16,
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
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      color: Warna.hitamTransparan,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Warna.ungu.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.assignment_return,
                              color: Warna.ungu,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pengembalian.kodePeminjaman,
                                  style: TextStyle(
                                    color: Warna.putih,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  pengembalian.namaPeminjam,
                                  style: TextStyle(
                                    color: Warna.putih.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 12,
                                      color: Warna.putih.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      pengembalian.tanggalKembaliFormatted,
                                      style: TextStyle(
                                        color: Warna.putih.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
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
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (pengembalian.terlambatHari > 0) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Terlambat ${pengembalian.terlambatHari} Hari',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Warna.abuAbu,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Warna.putih.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Warna.putih,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () =>
                                    _confirmDelete(context, pengembalian.id),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Warna.abuAbu,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Warna.putih.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Warna.putih,
                                    size: 16,
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

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Warna.hitamBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Warna.putih.withOpacity(0.2)),
        ),
        title: Text(
          'Hapus Pengembalian?',
          style: TextStyle(color: Warna.putih),
        ),
        content: Text(
          'Data pengembalian akan dihapus permanen.',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Warna.putih)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deletePengembalian(id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
