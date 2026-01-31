import 'package:jari/app/modules/admin/models/peminjaman_model.dart';
import 'package:jari/app/modules/admin/models/pengguna_model.dart';

/// Enum untuk status pengembalian
enum StatusPengembalian { menunggu, selesai }

/// Extension untuk konversi status pengembalian
extension StatusPengembalianExtension on StatusPengembalian {
  String get value {
    switch (this) {
      case StatusPengembalian.menunggu:
        return 'menunggu';
      case StatusPengembalian.selesai:
        return 'selesai';
    }
  }

  String get displayName {
    switch (this) {
      case StatusPengembalian.menunggu:
        return 'Menunggu';
      case StatusPengembalian.selesai:
        return 'Selesai';
    }
  }

  static StatusPengembalian fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'selesai':
        return StatusPengembalian.selesai;
      default:
        return StatusPengembalian.menunggu;
    }
  }
}

/// Model class untuk data pengembalian dari tabel public.pengembalian
class Pengembalian {
  final String id;
  final String peminjamanId;
  final String? petugasId;
  final DateTime tanggalKembali;
  final int terlambatHari;
  final int denda;
  final StatusPengembalian status;
  final DateTime? dibuatPada;
  final DateTime? updatedAt;

  // Relasi
  final Peminjaman? peminjaman;
  final Pengguna? petugas;

  Pengembalian({
    required this.id,
    required this.peminjamanId,
    this.petugasId,
    required this.tanggalKembali,
    this.terlambatHari = 0,
    this.denda = 0,
    this.status = StatusPengembalian.menunggu,
    this.dibuatPada,
    this.updatedAt,
    this.peminjaman,
    this.petugas,
  });

  /// Factory method untuk parsing data dari Supabase
  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'] as String,
      peminjamanId: json['peminjaman_id'] as String,
      petugasId: json['petugas_id'] as String?,
      tanggalKembali: DateTime.parse(json['tanggal_kembali'] as String),
      terlambatHari: int.tryParse(json['terlambat_hari'].toString()) ?? 0,
      denda: int.tryParse(json['total_denda'].toString()) ?? 0,
      status: StatusPengembalianExtension.fromString(json['status'] as String?),
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.tryParse(json['dibuat_pada'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      // Parse nested peminjaman data
      peminjaman: json['peminjaman'] != null
          ? Peminjaman.fromJson(json['peminjaman'] as Map<String, dynamic>)
          : null,
      // Parse nested petugas data
      petugas: json['petugas'] != null
          ? Pengguna.fromJson(json['petugas'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert ke Map untuk insert/update ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'peminjaman_id': peminjamanId,
      'petugas_id': petugasId,
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T').first,
      'terlambat_hari': terlambatHari,
      'total_denda': denda,
      'status': status.value,
    };
  }

  /// Format tanggal untuk display
  String get tanggalKembaliFormatted {
    return '${tanggalKembali.day.toString().padLeft(2, '0')}/${tanggalKembali.month.toString().padLeft(2, '0')}/${tanggalKembali.year}';
  }

  String get dendaFormatted {
    return 'Rp ${denda.toStringAsFixed(0)}'; // Basic formatting
  }

  /// Kode peminjaman untuk display
  String get kodePeminjaman => peminjaman?.kodePeminjaman ?? '-';

  /// Nama peminjam untuk display
  String get namaPeminjam => peminjaman?.namaPeminjam ?? 'Unknown';

  /// Copy with method
  Pengembalian copyWith({
    String? id,
    String? peminjamanId,
    String? petugasId,
    DateTime? tanggalKembali,
    int? terlambatHari,
    int? denda,
    StatusPengembalian? status,
    DateTime? dibuatPada,
    DateTime? updatedAt,
    Peminjaman? peminjaman,
    Pengguna? petugas,
  }) {
    return Pengembalian(
      id: id ?? this.id,
      peminjamanId: peminjamanId ?? this.peminjamanId,
      petugasId: petugasId ?? this.petugasId,
      tanggalKembali: tanggalKembali ?? this.tanggalKembali,
      terlambatHari: terlambatHari ?? this.terlambatHari,
      denda: denda ?? this.denda,
      status: status ?? this.status,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      updatedAt: updatedAt ?? this.updatedAt,
      peminjaman: peminjaman ?? this.peminjaman,
      petugas: petugas ?? this.petugas,
    );
  }
}
