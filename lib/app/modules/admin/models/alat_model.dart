import 'package:benang_merah/app/modules/admin/models/kategori_alat_model.dart';

/// Model untuk Alat
class Alat {
  final String id;
  final String kodeAlat;
  final String namaAlat;
  final String? kategoriId;
  final int stokTotal;
  final int stokTersedia;
  final bool aktif;
  final String? alatUrl;
  final DateTime? dibuatPada;
  final KategoriAlat? kategori; // Relasi ke kategori

  Alat({
    required this.id,
    required this.kodeAlat,
    required this.namaAlat,
    this.kategoriId,
    required this.stokTotal,
    required this.stokTersedia,
    this.aktif = true,
    this.alatUrl,
    this.dibuatPada,
    this.kategori,
  });

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id'] as String,
      kodeAlat: json['kode_alat'] as String,
      namaAlat: json['nama_alat'] as String,
      kategoriId: json['kategori_id'] as String?,
      stokTotal: json['stok_total'] as int,
      stokTersedia: json['stok_tersedia'] as int,
      aktif: json['aktif'] as bool? ?? true,
      alatUrl: json['alat_url'] as String?,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      kategori: json['kategori_alat'] != null
          ? KategoriAlat.fromJson(json['kategori_alat'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_alat': kodeAlat,
      'nama_alat': namaAlat,
      'kategori_id': kategoriId,
      'stok_total': stokTotal,
      'stok_tersedia': stokTersedia,
      'aktif': aktif,
      'alat_url': alatUrl,
    };
  }

  Alat copyWith({
    String? id,
    String? kodeAlat,
    String? namaAlat,
    String? kategoriId,
    int? stokTotal,
    int? stokTersedia,
    bool? aktif,
    String? alatUrl,
    DateTime? dibuatPada,
    KategoriAlat? kategori,
  }) {
    return Alat(
      id: id ?? this.id,
      kodeAlat: kodeAlat ?? this.kodeAlat,
      namaAlat: namaAlat ?? this.namaAlat,
      kategoriId: kategoriId ?? this.kategoriId,
      stokTotal: stokTotal ?? this.stokTotal,
      stokTersedia: stokTersedia ?? this.stokTersedia,
      aktif: aktif ?? this.aktif,
      alatUrl: alatUrl ?? this.alatUrl,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      kategori: kategori ?? this.kategori,
    );
  }

  /// Nama kategori untuk display
  String get namaKategori => kategori?.namaKategori ?? 'Tidak ada kategori';
}
