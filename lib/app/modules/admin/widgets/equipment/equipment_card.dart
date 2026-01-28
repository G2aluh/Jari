import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/modules/admin/models/alat_model.dart';
import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final Alat alat;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const EquipmentCard({
    super.key,
    required this.alat,
    required this.onEdit,
    required this.onToggleStatus,
  });

  Color _getStockColor(int stock) {
    if (stock == 0) {
      return Colors.red;
    } else if (stock < 5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: alat.aktif ? 1.0 : 0.5,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: alat.aktif
                ? Warna.putih.withOpacity(0.2)
                : Colors.red.withOpacity(0.3),
          ),
          color: Warna.hitamTransparan,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Warna.abuAbu,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Warna.putih.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: alat.alatUrl != null && alat.alatUrl!.isNotEmpty
                      ? Image.network(
                          alat.alatUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: Warna.putih.withOpacity(0.5),
                          ),
                        )
                      : Icon(Icons.build, color: Warna.putih.withOpacity(0.5)),
                ),
              ),
              SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alat.namaAlat,
                            style: TextStyle(
                              color: Warna.putih,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!alat.aktif)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Nonaktif',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      alat.kodeAlat,
                      style: TextStyle(
                        color: Warna.putih.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      alat.namaKategori,
                      style: TextStyle(color: Warna.putih.withOpacity(0.7)),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Stok: ${alat.stokTersedia}/${alat.stokTotal}',
                      style: TextStyle(
                        color: _getStockColor(alat.stokTersedia),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),

              // Actions
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.edit, color: Warna.putih, size: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: onToggleStatus,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Warna.abuAbu,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Warna.putih.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.stop_circle,
                        color: alat.aktif ? Colors.red : Warna.putih,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
