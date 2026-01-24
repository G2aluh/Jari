import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:benang_merah/app/modules/peminjam/views/dialog/pengajuan_peminjaman_dialog.dart';

class PeminjamDashboardController extends GetxController {
  // State
  var showBadge = false.obs;
  var isSearchActive = false.obs;
  final TextEditingController searchController = TextEditingController();

  var rentedItems = <int>{}.obs;
  var rentedNewItem = <String>{}.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleRent(int index) {
    if (rentedItems.contains(index)) {
      rentedItems.remove(index);
    } else {
      rentedItems.add(index);
    }
    _updateBadgeVisibility();
  }

  void toggleRentNewItem(String itemName) {
    if (rentedNewItem.contains(itemName)) {
      rentedNewItem.remove(itemName);
    } else {
      rentedNewItem.add(itemName);
    }
    _updateBadgeVisibility();
  }

  void toggleSearch() {
    if (isSearchActive.value) {
      isSearchActive.value = false;
      searchController.clear();
    } else {
      isSearchActive.value = true;
    }
  }

  void _updateBadgeVisibility() {
    showBadge.value = rentedItems.isNotEmpty || rentedNewItem.isNotEmpty;
  }

  void showRentalSelectionDialog(BuildContext context) {
    if (showBadge.value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RentalSelectionDialog(
            rentedItems: rentedItems,
            rentedNewItem: rentedNewItem,
            alatList: alatList,
            alatProdukBaruList: alatProdukBaruList,
          );
        },
      );
    } else {
      // Fluttertoast.showToast(
      //   msg: "Pilih barang untuk disewa terlebih dahulu",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red,
      //   timeInSecForIosWeb: 2,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );

      //snackbar
      Get.snackbar(
        "Peringatan",
        "Pilih barang untuk disewa terlebih dahulu",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
    }
  }

  void showHistorySelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSelectionItem(
              icon: Icons.history,
              title: "Riwayat Peminjaman",
              onTap: () {
                Get.back();
                Get.toNamed('/riwayat-peminjam');
              },
            ),
            Divider(),
            _buildSelectionItem(
              icon: Icons.assignment_return,
              title: "Pengembalian Alat",
              onTap: () {
                Get.back();
                Get.toNamed('/return-equipment');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
