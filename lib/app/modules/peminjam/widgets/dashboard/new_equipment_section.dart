import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/peminjam/widgets/common/stock_container.dart';
import 'package:flutter/material.dart';

class NewEquipmentSection extends StatelessWidget {
  final PeminjamDashboardController controller;

  const NewEquipmentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final alat = controller.alatTerbaru;
    if (alat == null) return const SizedBox.shrink();

    // Responsive sizing - LARGER FOR TABLET
    final isTablet = Responsive.isTablet(context);
    final padding = isTablet ? 32.0 : 16.0;
    final titleSize = isTablet ? 26.0 : 22.0;
    final imageSize = isTablet ? 90.0 : 60.0;
    final containerPadding = isTablet ? 24.0 : 14.0;
    final nameSize = isTablet ? 20.0 : 16.0;
    final subtitleSize = isTablet ? 16.0 : 12.0;
    final badgeFontSize = isTablet ? 14.0 : 12.0;
    final badgePaddingH = isTablet ? 12.0 : 8.0;
    final badgePaddingV = isTablet ? 4.0 : 2.0;
    final borderRadius = isTablet ? 16.0 : 10.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Alat Baru",
                style: AppTextStyles.barangTerbaikText.copyWith(
                  fontSize: titleSize,
                ),
              ),
              SizedBox(width: isTablet ? 14 : 10),
              // NewContainer badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: badgePaddingH,
                  vertical: badgePaddingV,
                ),
                decoration: BoxDecoration(
                  color: Warna.ungu,
                  borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
                ),
                child: Text(
                  "New",
                  style: AppTextStyles.stokText.copyWith(
                    fontSize: badgeFontSize,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: isTablet ? 20 : 16),
            padding: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              color: Warna.ungu.withOpacity(0.15),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  margin: EdgeInsets.only(right: isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    color: Warna.putih,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                      alat['alat_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: isTablet ? 40 : 30,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              alat['nama_alat'],
                              style: AppTextStyles.namaBarangText.copyWith(
                                fontSize: nameSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: isTablet ? 12 : 8),
                          StockContainer(
                            stock: alat['stok_tersedia'].toString(),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Text(
                        "Sewa Sekarang! Sebelum Kehabisan",
                        style: AppTextStyles.produkBaruText.copyWith(
                          fontSize: subtitleSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 16 : 8),
        ],
      ),
    );
  }
}
