class AturanDenda {
  final String id;
  final String jenis;
  final num nilaiDenda;
  final String? keterangan;
  final bool aktif;

  AturanDenda({
    required this.id,
    required this.jenis,
    required this.nilaiDenda,
    this.keterangan,
    this.aktif = true,
  });

  factory AturanDenda.fromJson(Map<String, dynamic> json) {
    return AturanDenda(
      id: json['id'] as String,
      jenis: json['jenis'] as String,
      nilaiDenda: json['nilai_denda'] as num,
      keterangan: json['keterangan'] as String?,
      aktif: json['aktif'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis': jenis,
      'nilai_denda': nilaiDenda,
      'keterangan': keterangan,
      'aktif': aktif,
    };
  }
}
