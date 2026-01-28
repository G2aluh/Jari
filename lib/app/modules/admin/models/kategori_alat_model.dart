/// Model untuk Kategori Alat
class KategoriAlat {
  final String id;
  final String namaKategori;
  final String? deskripsi;
  final int iconCode;
  final String iconFamily;
  final String? iconPackage;
  final DateTime? dibuatPada;

  KategoriAlat({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.iconCode = 0,
    this.iconFamily = 'MaterialIcons',
    this.iconPackage,
    this.dibuatPada,
  });

  factory KategoriAlat.fromJson(Map<String, dynamic> json) {
    // Handle different possible column names
    final String nama =
        json['nama_kategori'] as String? ??
        json['nama'] as String? ??
        json['name'] as String? ??
        'Unknown';

    return KategoriAlat(
      id: json['id'] as String,
      namaKategori: nama,
      deskripsi: json['deskripsi'] as String? ?? json['description'] as String?,
      iconCode: json['icon_code'] as int? ?? 0,
      iconFamily: json['icon_family'] as String? ?? 'MaterialIcons',
      iconPackage: json['icon_package'] as String?,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_kategori': namaKategori,
      'deskripsi': deskripsi,
      'icon_code': iconCode,
      'icon_family': iconFamily,
      'icon_package': iconPackage,
    };
  }

  KategoriAlat copyWith({
    String? id,
    String? namaKategori,
    String? deskripsi,
    int? iconCode,
    String? iconFamily,
    String? iconPackage,
    DateTime? dibuatPada,
  }) {
    return KategoriAlat(
      id: id ?? this.id,
      namaKategori: namaKategori ?? this.namaKategori,
      deskripsi: deskripsi ?? this.deskripsi,
      iconCode: iconCode ?? this.iconCode,
      iconFamily: iconFamily ?? this.iconFamily,
      iconPackage: iconPackage ?? this.iconPackage,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}
