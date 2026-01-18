import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:benang_merah/app/core/theme/app_text_styles.dart';
import 'package:benang_merah/app/modules/alat/views/peminjam/alat_list_peminjam_view.dart';
import 'package:benang_merah/app/modules/auth/controllers/auth_controller.dart';
import 'package:benang_merah/app/modules/kategori/views/kategori_list_view.dart';
import 'package:benang_merah/app/modules/peminjam/views/dialog/pengajuan_peminjaman_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:benang_merah/app/routes/app_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PeminjamDashboardView extends StatefulWidget {
  const PeminjamDashboardView({super.key});

  @override
  State<PeminjamDashboardView> createState() => _PeminjamDashboardViewState();
}

class _PeminjamDashboardViewState extends State<PeminjamDashboardView> {
  bool _showBadge = false;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  Set<int> _rentedItems = <int>{};
  Set<String> _rentedNewItem = <String>{};

  void _toggleRent(int index) {
    setState(() {
      if (_rentedItems.contains(index)) {
        _rentedItems.remove(index);
      } else {
        _rentedItems.add(index);
      }
      _updateBadgeVisibility();
    });
  }

  void _toggleRentNewItem(String itemName) {
    setState(() {
      if (_rentedNewItem.contains(itemName)) {
        _rentedNewItem.remove(itemName);
      } else {
        _rentedNewItem.add(itemName);
      }
      _updateBadgeVisibility();
    });
  }

  void _updateBadgeVisibility() {
    setState(() {
      _showBadge = _rentedItems.isNotEmpty || _rentedNewItem.isNotEmpty;
    });
  }

  void _showRentalSelectionDialog() {
    if (_showBadge) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RentalSelectionDialog(
            rentedItems: _rentedItems,
            rentedNewItem: _rentedNewItem,
            alatList: alatList,
            alatProdukBaruList: alatProdukBaruList,
          );
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: "Pilih barang untuk disewa terlebih dahulu",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Warna.hitamBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.hitamBackground,
        foregroundColor: Warna.putih,
        title: _isSearchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Warna.putih),
                decoration: InputDecoration(
                  hintText: "Cari barang...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              )
            : ActionChip(
                label: Text("Peminjaman Barang"),
                labelStyle: TextStyle(color: Warna.putih),
                avatar: Icon(IconlyBold.scan, color: Warna.putih),
                shape: StadiumBorder(),
                side: BorderSide(width: 0),
                backgroundColor: Warna.hitamTransparan,
                onPressed: () {},
              ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          onPressed: () {
            setState(() {
              if (_isSearchActive) {
                _isSearchActive = false;
                _searchController.clear();
              } else {
                _isSearchActive = true;
              }
            });
          },
          icon: Icon(_isSearchActive ? Icons.arrow_back : IconlyLight.search),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              authController.logout();
              Get.offAllNamed('/login');
            },
            icon: Icon(IconlyLight.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Kategori Barang',
                    style: AppTextStyles.primaryText,
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      final kategori = kategoriList[index];
                      return Container(
                        width: 90,
                        padding: EdgeInsets.all(4),
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kategori.warna,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //KATEGORI
                            Icon(
                              kategori.icon,
                              size: kategori.ukuranIcon.width,
                              color: kategori.warnaIcon,
                            ),
                            SizedBox(height: 8),
                            //NAMA KATEGORI
                            Text(
                              kategori.nama,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: kategori.warnaNama,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, int index) =>
                        SizedBox(width: 16),
                    itemCount: kategoriList.length,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.67,
            ),
            decoration: BoxDecoration(
              color: Warna.putih,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Alat Untuk Disewa",
                        style: AppTextStyles.barangTerbaikText,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(IconlyLight.infoSquare),
                        label: Text("Geser"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final alat = alatList[index];

                      //Card Alat
                      return SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //GAMBAR
                            Container(
                              width: double.maxFinite,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                                image: DecorationImage(
                                  image: AssetImage(alat.gambar),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Warna.hitamTransparan,
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      //Stok
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              alat.stok,
                                              style: AppTextStyles.stokText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //NAMA BARANG
                            Text(
                              alat.nama,
                              style: AppTextStyles.namaBarangText,
                            ),

                            //Sewa Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: _rentedItems.contains(index)
                                    ? Colors.grey
                                    : Warna.ungu,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _toggleRent(index),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _rentedItems.contains(index)
                                        ? "Disewa"
                                        : "Sewa",
                                    style: AppTextStyles.stokText,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    IconlyBold.bag,
                                    size: 16,
                                    color: Warna.putih,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 15),
                    itemCount: alatList.length,
                  ),
                ),

                //ALAT BARU
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Alat Baru",
                            style: AppTextStyles.barangTerbaikText.copyWith(
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(width: 10),
                          //NewContainer
                          Container(
                            padding: EdgeInsets.only(
                              top: 0,
                              bottom: 0,
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Warna.ungu,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("New", style: AppTextStyles.stokText),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Warna.ungu.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Warna.putih,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/mesinObras.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Mesin Obras",
                                      style: AppTextStyles.namaBarangText,
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Warna.hitamTransparan,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "12",
                                              style: AppTextStyles.stokText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Sewa Sekarang! Sebelum Kehabisan",
                                      style: AppTextStyles.produkBaruText,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SewaProdukBaruButton
                      Padding(
                        padding: const EdgeInsets.only(right: 240),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                _rentedNewItem.contains("Mesin Obras")
                                ? Colors.grey
                                : Warna.ungu,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _toggleRentNewItem("Mesin Obras"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _rentedNewItem.contains("Mesin Obras")
                                    ? "Disewa"
                                    : "Sewa",
                                style: AppTextStyles.stokText,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                IconlyBold.bag,
                                size: 16,
                                color: Warna.putih,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Warna.putih,
        selectedItemColor: Warna.ungu,
        unselectedItemColor: Warna.hitamBackground.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          if (value == 1) {
            Get.toNamed(Routes.riwayatPeminjam);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.category),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              alignment: Alignment(1, -1.5),
              backgroundColor: Warna.ungu,
              child: Icon(IconlyBold.timeCircle),
            ),
            label: "Riwayat",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Warna.ungu.withOpacity(0.2), spreadRadius: 5),
          ],
        ),
        child: _showBadge
            ? Badge(
                alignment: Alignment(1.2, -1.2),
                backgroundColor: Warna.ungu,
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: _showRentalSelectionDialog,
                  backgroundColor: Warna.ungu,
                  foregroundColor: Warna.putih,
                  child: Icon(Icons.add),
                ),
              )
            : FloatingActionButton(
                elevation: 0,
                onPressed: _showRentalSelectionDialog,
                backgroundColor: Warna.ungu,
                foregroundColor: Warna.putih,
                child: Icon(Icons.add),
              ),
      ),
    );
  }
}
