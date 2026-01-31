import 'package:jari/app/modules/admin/models/alat_model.dart';

/// Enum untuk kondisi alat
enum KondisiAlat { baik, rusak, hilang }

/// Extension untuk konversi kondisi
extension KondisiAlatExtension on KondisiAlat {
  String get value {
    switch (this) {
      case KondisiAlat.baik:
        return 'baik';
      case KondisiAlat.rusak:
        return 'rusak';
      case KondisiAlat.hilang:
        return 'hilang';
    }
  }

  String get displayName {
    switch (this) {
      case KondisiAlat.baik:
        return 'Baik';
      case KondisiAlat.rusak:
        return 'Rusak';
      case KondisiAlat.hilang:
        return 'Hilang';
    }
  }

  static KondisiAlat fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'rusak':
        return KondisiAlat.rusak;
      case 'hilang':
        return KondisiAlat.hilang;
      default:
        return KondisiAlat.baik;
    }
  }
}

/// Model untuk detail peminjaman (alat yang dipinjam)
class DetailPeminjaman {
  final String id;
  final String peminjamanId;
  final String alatId;
  final int jumlah;
  final KondisiAlat? kondisiKembali;
  final DateTime? dibuatPada;

  // Relasi ke alat
  final Alat? alat;

  DetailPeminjaman({
    required this.id,
    required this.peminjamanId,
    required this.alatId,
    required this.jumlah,
    this.kondisiKembali,
    this.dibuatPada,
    this.alat,
  });

  factory DetailPeminjaman.fromJson(Map<String, dynamic> json) {
    return DetailPeminjaman(
      id: json['id'] as String,
      peminjamanId: json['peminjaman_id'] as String,
      alatId: json['alat_id'] as String,
      jumlah: json['jumlah'] as int,
      kondisiKembali: json['kondisi_kembali'] != null
          ? KondisiAlatExtension.fromString(json['kondisi_kembali'] as String?)
          : null,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.tryParse(json['dibuat_pada'] as String)
          : null,
      alat: json['alat'] != null
          ? Alat.fromJson(json['alat'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peminjaman_id': peminjamanId,
      'alat_id': alatId,
      'jumlah': jumlah,
      if (kondisiKembali != null) 'kondisi_kembali': kondisiKembali!.value,
    };
  }

  /// Nama alat untuk display
  String get namaAlat => alat?.namaAlat ?? 'Unknown';

  /// Kode alat untuk display
  String get kodeAlat => alat?.kodeAlat ?? '-';

  DetailPeminjaman copyWith({
    String? id,
    String? peminjamanId,
    String? alatId,
    int? jumlah,
    KondisiAlat? kondisiKembali,
    DateTime? dibuatPada,
    Alat? alat,
  }) {
    return DetailPeminjaman(
      id: id ?? this.id,
      peminjamanId: peminjamanId ?? this.peminjamanId,
      alatId: alatId ?? this.alatId,
      jumlah: jumlah ?? this.jumlah,
      kondisiKembali: kondisiKembali ?? this.kondisiKembali,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      alat: alat ?? this.alat,
    );
  }
}

/// Helper class for temporarily holding alat selection (before saving to DB)
class AlatSelection {
  final Alat alat;
  int jumlah;

  AlatSelection({required this.alat, this.jumlah = 1});
}
