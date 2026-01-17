class Alat {
  final String nama;
  final String stok;
  final String gambar;

  Alat({
    required this.nama,
    required this.stok,
    required this.gambar,
  });
}

List<Alat> alatList = [
  Alat(
    nama: 'Benang Jahit',
    stok: '23',
    gambar: 'assets/images/benang.png',
  ),
  Alat(
    nama: 'Gunting',
    stok: '3',
    gambar: 'assets/images/gunting.png',
  ),
  Alat(
    nama: 'Mesin Jahit',
    stok: '12',
    gambar: 'assets/images/mesinJahit.png',
  ),
  Alat(
    nama: 'Setrika',
    stok: '6',
    gambar: 'assets/images/setrika.png',
  ),
];

class AlatProdukBaru {
  final String nama;
  final String stok;
  final String gambar;

  AlatProdukBaru({
    required this.nama,
    required this.stok,
    required this.gambar,
  });
}

List<AlatProdukBaru> alatProdukBaruList = [
  AlatProdukBaru(
    nama: 'Benang Jahit',
    stok: '23',
    gambar: 'assets/images/benang.png',
  ),
  AlatProdukBaru(
    nama: 'Mesin Obras',
    stok: '3',
    gambar: 'assets/images/mesinObras.png',
  ),

];
