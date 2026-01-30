import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/modules/admin/controllers/log_aktivitas_controller.dart';
import 'package:jari/app/modules/admin/models/log_aktivitas_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityLogView extends StatelessWidget {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(LogAktivitasController());

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log Aktivitas',
                style: TextStyle(
                  color: Warna.putih,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => controller.refreshLogs(),
                icon: Icon(Icons.refresh, color: Warna.putih),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Log list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.logList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Warna.putih.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada log aktivitas',
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshLogs(),
                child: ListView.separated(
                  itemCount: controller.logList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final log = controller.logList[index];
                    return _buildLogItem(log);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(LogAktivitas log) {
    // Determine icon and color based on activity text
    IconData icon = Icons.info;
    Color color = Warna.ungu;

    final aktivitasLower = log.aktivitas.toLowerCase();

    if (aktivitasLower.contains('login')) {
      icon = Icons.login;
      color = Warna.ungu;
    } else if (aktivitasLower.contains('logout')) {
      icon = Icons.logout;
      color = Warna.kuning;
    } else if (aktivitasLower.contains('tambah') ||
        aktivitasLower.contains('create') ||
        aktivitasLower.contains('buat')) {
      icon = Icons.add_circle;
      color = Colors.green;
    } else if (aktivitasLower.contains('hapus') ||
        aktivitasLower.contains('delete')) {
      icon = Icons.delete;
      color = Colors.red;
    } else if (aktivitasLower.contains('edit') ||
        aktivitasLower.contains('update') ||
        aktivitasLower.contains('ubah')) {
      icon = Icons.edit;
      color = Warna.kuning;
    } else if (aktivitasLower.contains('peminjaman')) {
      icon = Icons.inventory_2;
      color = Warna.ungu;
    } else if (aktivitasLower.contains('pengembalian') ||
        aktivitasLower.contains('kembali')) {
      icon = Icons.undo;
      color = Colors.green;
    } else if (aktivitasLower.contains('setuju') ||
        aktivitasLower.contains('approve') ||
        aktivitasLower.contains('verifikasi')) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (aktivitasLower.contains('tolak') ||
        aktivitasLower.contains('reject')) {
      icon = Icons.cancel;
      color = Colors.red;
    } else if (aktivitasLower.contains('alat') ||
        aktivitasLower.contains('equipment')) {
      icon = Icons.build;
      color = Warna.kuning;
    } else if (aktivitasLower.contains('pengguna') ||
        aktivitasLower.contains('user')) {
      icon = Icons.person;
      color = Warna.putih;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Warna.putih.withOpacity(0.2)),
        color: Warna.hitamTransparan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          log.aktivitas,
          style: const TextStyle(
            color: Warna.putih,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${log.namaPengguna} - ${log.tanggalFormatted}',
          style: TextStyle(color: Warna.putih.withOpacity(0.7)),
        ),
      ),
    );
  }
}
