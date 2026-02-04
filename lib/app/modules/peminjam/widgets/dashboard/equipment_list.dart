import 'package:jari/app/core/theme/app_colors.dart';
import 'package:jari/app/core/theme/app_text_styles.dart';
import 'package:jari/app/core/utils/responsive.dart';
import 'package:jari/app/modules/peminjam/controllers/peminjam_dashboard_controller.dart';
import 'package:jari/app/modules/peminjam/widgets/common/stock_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class EquipmentList extends StatelessWidget {
  final PeminjamDashboardController controller;

  const EquipmentList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final hPadding = isTablet ? 24.0 : 16.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(hPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Alat Untuk Disewa",
                style: AppTextStyles.barangTerbaikText,
              ),
              if (!isTablet)
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(IconlyLight.infoSquare),
                  label: Text("Geser"),
                ),
            ],
          ),
        ),
        Obx(() {
          if (controller.alatList.isEmpty) {
            return _buildEmptyState(context);
          }

          // Tablet: Grid layout (5 per row)
          // Mobile: Horizontal scroll
          if (isTablet) {
            return _buildTabletGridLayout(context);
          } else {
            return _buildMobileHorizontalLayout(context);
          }
        }),
      ],
    );
  }

  // Empty state
  Widget _buildEmptyState(BuildContext context) {
    final cardHeight = R.cardHeight(context);
    final kategoriNama = controller.selectedKategoriNama;

    return SizedBox(
      height: cardHeight,
      child: Center(
        child: Text(
          kategoriNama.isNotEmpty
              ? 'Tidak ada alat untuk kategori $kategoriNama'
              : 'Tidak ada alat tersedia',
          style: AppTextStyles.primaryText.copyWith(
            color: Colors.grey,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Mobile: Horizontal scroll layout (existing behavior)
  Widget _buildMobileHorizontalLayout(BuildContext context) {
    final cardWidth = R.cardWidth(context);
    final cardHeight = R.cardHeight(context);
    final imageHeight = R.imageHeight(context);
    final spacing = 15.0;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildEquipmentCard(
            context: context,
            index: index,
            cardWidth: cardWidth,
            imageHeight: imageHeight,
            isTablet: false,
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemCount: controller.alatList.length,
      ),
    );
  }

  // Tablet: Grid layout (5 items per row)
  Widget _buildTabletGridLayout(BuildContext context) {
    const int itemsPerRow = 5;
    final hPadding = 24.0;
    final spacing = 16.0;
    final halfSpacing = spacing / 2;

    // Calculate how many rows we need
    final itemCount = controller.alatList.length;
    final rowCount = (itemCount / itemsPerRow).ceil();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPadding - halfSpacing),
      child: Column(
        children: List.generate(rowCount, (rowIndex) {
          final startIndex = rowIndex * itemsPerRow;
          final endIndex = (startIndex + itemsPerRow).clamp(0, itemCount);
          final rowItems = controller.alatList.sublist(startIndex, endIndex);

          return Padding(
            padding: EdgeInsets.only(
              bottom: rowIndex < rowCount - 1 ? spacing : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...rowItems.asMap().entries.map((entry) {
                  final localIndex = entry.key;
                  final globalIndex = startIndex + localIndex;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: halfSpacing),
                      child: _buildEquipmentCard(
                        context: context,
                        index: globalIndex,
                        cardWidth: double.infinity,
                        imageHeight: 140.0,
                        isTablet: true,
                      ),
                    ),
                  );
                }),
                // Fill empty slots with empty Expanded to maintain grid alignment
                ...List.generate(itemsPerRow - rowItems.length, (emptyIndex) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: halfSpacing),
                      child: const SizedBox(),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Shared equipment card builder
  Widget _buildEquipmentCard({
    required BuildContext context,
    required int index,
    required double cardWidth,
    required double imageHeight,
    required bool isTablet,
  }) {
    final alat = controller.alatList[index];
    final isRented = controller.rentedItems.contains(index);

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Stock + Name
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: NetworkImage(alat['alat_url']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: StockContainer(
                      stock: alat['stok_tersedia'].toString(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        alat['nama_alat'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.namaBarangText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: isTablet ? 13 : 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 18),
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: isRented ? Colors.grey : Warna.ungu,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => controller.toggleRent(index),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRented ? "Disewa" : "Sewa",
                    style: AppTextStyles.stokText.copyWith(
                      fontSize: isTablet ? 12 : 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    IconlyBold.bag,
                    size: isTablet ? 14 : 16,
                    color: Warna.putih,
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
