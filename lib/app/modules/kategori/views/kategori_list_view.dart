import 'package:benang_merah/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class Kategori{
  final String nama;
  final IconData icon;
  final Color warna;
  final Color warnaIcon;
  final Color warnaNama;
  final Size ukuranIcon;

  Kategori({required this.nama, required this.ukuranIcon, required this.icon, required this.warna, required this.warnaIcon, required this.warnaNama});
}

List<Kategori> kategoriList = [
  Kategori(nama: 'Elektronik', ukuranIcon: Size(34, 34), icon: Icons.electrical_services_outlined, warna: Warna.hitamTransparan, warnaIcon: Warna.putih, warnaNama: Warna.putih),
  Kategori(nama: 'Menjahit', ukuranIcon: Size(34, 34), icon: Icons.cut, warna: Warna.hitamTransparan, warnaIcon: Warna.putih, warnaNama: Warna.putih),
  Kategori(nama: 'Desain', ukuranIcon: Size(34, 34), icon: Icons.design_services_outlined, warna: Warna.hitamTransparan, warnaIcon: Warna.putih, warnaNama: Warna.putih),
  Kategori(nama: 'Pola', ukuranIcon: Size(34, 34), icon: Icons.format_shapes_outlined, warna: Warna.hitamTransparan, warnaIcon: Warna.putih, warnaNama: Warna.putih),
];
