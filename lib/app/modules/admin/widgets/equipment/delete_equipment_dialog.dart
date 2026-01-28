import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/controllers/equipment_controller.dart';
import 'package:benang_merah/app/modules/admin/models/alat_model.dart';
import 'package:flutter/material.dart';

class DeleteEquipmentDialog extends StatefulWidget {
  final Alat alat;
  final EquipmentController controller;

  const DeleteEquipmentDialog({
    super.key,
    required this.alat,
    required this.controller,
  });

  @override
  State<DeleteEquipmentDialog> createState() => _DeleteEquipmentDialogState();
}

class _DeleteEquipmentDialogState extends State<DeleteEquipmentDialog> {
  bool isLoading = false;

  Future<void> _handleToggle() async {
    setState(() => isLoading = true);

    bool success;
    if (widget.alat.aktif) {
      success = await widget.controller.deleteEquipment(widget.alat.id);
    } else {
      success = await widget.controller.activateEquipment(widget.alat.id);
    }

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.alat.aktif;

    return AlertDialog(
      backgroundColor: Warna.hitamBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Warna.putih.withOpacity(0.2)),
      ),
      title: Row(
        children: [
          Text(
            isActive ? 'Nonaktifkan Alat' : 'Aktifkan Alat',
            style: TextStyle(color: Warna.putih),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActive
                ? 'Apakah Anda yakin ingin menonaktifkan alat ini?'
                : 'Apakah Anda yakin ingin mengaktifkan kembali alat ini?',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Warna.hitamTransparan,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? Colors.red.withOpacity(0.3)
                    : Colors.green.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                // Image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Warna.abuAbu,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        widget.alat.alatUrl != null &&
                            widget.alat.alatUrl!.isNotEmpty
                        ? Image.network(
                            widget.alat.alatUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.build,
                              color: Warna.putih.withOpacity(0.5),
                              size: 20,
                            ),
                          )
                        : Icon(
                            Icons.build,
                            color: Warna.putih.withOpacity(0.5),
                            size: 20,
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alat.namaAlat,
                        style: TextStyle(
                          color: Warna.putih,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.alat.kodeAlat,
                        style: TextStyle(
                          color: Warna.putih.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            isActive
                ? '*Alat tidak akan muncul dalam daftar peminjaman'
                : '*Alat akan dapat dipinjam kembali',
            style: TextStyle(
              color: isActive ? Colors.orange : Colors.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: TextStyle(color: Warna.putih.withOpacity(0.7)),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? Colors.red : Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isLoading ? null : _handleToggle,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Warna.putih,
                  ),
                )
              : Text(
                  isActive ? 'Nonaktifkan' : 'Aktifkan',
                  style: TextStyle(color: Warna.putih),
                ),
        ),
      ],
    );
  }
}
