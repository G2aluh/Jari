import 'package:jari/app/modules/admin/models/pengguna_model.dart';

/// Enum untuk status peminjaman
enum StatusPeminjaman { menunggu, disetujui, ditolak, selesai }

/// Extension untuk konversi status
extension StatusPeminjamanExtension on StatusPeminjaman {
  String get value {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return 'menunggu';
      case StatusPeminjaman.disetujui:
        return 'disetujui';
      case StatusPeminjaman.ditolak:
        return 'ditolak';
      case StatusPeminjaman.selesai:
        return 'selesai';
    }
  }

  String get displayName {
    switch (this) {
      case StatusPeminjaman.menunggu:
        return 'Menunggu';
      case StatusPeminjaman.disetujui:
        return 'Disetujui';
      case StatusPeminjaman.ditolak:
        return 'Ditolak';
      case StatusPeminjaman.selesai:
        return 'Selesai';
    }
  }

  static StatusPeminjaman fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'disetujui':
        return StatusPeminjaman.disetujui;
      case 'ditolak':
        return StatusPeminjaman.ditolak;
      case 'selesai':
        return StatusPeminjaman.selesai;
      default:
        return StatusPeminjaman.menunggu;
    }
  }
}

/// Model class untuk data peminjaman dari tabel public.peminjaman
class Peminjaman {
  final String id;
  final String? kodePeminjaman;
  final String? peminjamId;
  final String? petugasId;
  final DateTime? tanggalPinjam;
  final DateTime? tanggalJatuhTempo;
  final double totalDenda;
  final StatusPeminjaman status;
  final String? catatanPenolakan;
  final DateTime? dibuatPada;
  final DateTime? updatedAt;

  // Relasi
  final Pengguna? peminjam;
  final Pengguna? petugas;

  Peminjaman({
    required this.id,
    this.kodePeminjaman,
    this.peminjamId,
    this.petugasId,
    this.tanggalPinjam,
    this.tanggalJatuhTempo,
    this.totalDenda = 0,
    this.status = StatusPeminjaman.menunggu,
    this.catatanPenolakan,
    this.dibuatPada,
    this.updatedAt,
    this.peminjam,
    this.petugas,
  });

  /// Factory method untuk parsing data dari Supabase
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'] as String,
      kodePeminjaman: json['kode_peminjaman'] as String?,
      peminjamId: json['peminjam_id'] as String?,
      petugasId: json['petugas_id'] as String?,
      tanggalPinjam: json['tanggal_pinjam'] != null
          ? DateTime.tryParse(json['tanggal_pinjam'] as String)
          : null,
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] != null
          ? DateTime.tryParse(json['tanggal_jatuh_tempo'] as String)
          : null,
      totalDenda: (json['total_denda'] as num?)?.toDouble() ?? 0,
      status: StatusPeminjamanExtension.fromString(json['status'] as String?),
      catatanPenolakan: json['catatan_penolakan'] as String?,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.tryParse(json['dibuat_pada'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      // Parse nested peminjam data
      peminjam: json['peminjam'] != null
          ? Pengguna.fromJson(json['peminjam'] as Map<String, dynamic>)
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
      'kode_peminjaman': kodePeminjaman,
      'peminjam_id': peminjamId,
      'petugas_id': petugasId,
      'tanggal_pinjam': tanggalPinjam?.toIso8601String().split('T').first,
      'tanggal_jatuh_tempo': tanggalJatuhTempo
          ?.toIso8601String()
          .split('T')
          .first,
      'total_denda': totalDenda,
      'status': status.value,
      'catatan_penolakan': catatanPenolakan,
    };
  }

  /// Format tanggal untuk display
  String get tanggalPinjamFormatted {
    if (tanggalPinjam == null) return '-';
    return '${tanggalPinjam!.day.toString().padLeft(2, '0')}/${tanggalPinjam!.month.toString().padLeft(2, '0')}/${tanggalPinjam!.year}';
  }

  String get tanggalJatuhTempoFormatted {
    if (tanggalJatuhTempo == null) return '-';
    return '${tanggalJatuhTempo!.day.toString().padLeft(2, '0')}/${tanggalJatuhTempo!.month.toString().padLeft(2, '0')}/${tanggalJatuhTempo!.year}';
  }

  /// Nama peminjam untuk display
  String get namaPeminjam => peminjam?.nama ?? 'Unknown';

  /// Copy with method
  Peminjaman copyWith({
    String? id,
    String? kodePeminjaman,
    String? peminjamId,
    String? petugasId,
    DateTime? tanggalPinjam,
    DateTime? tanggalJatuhTempo,
    double? totalDenda,
    StatusPeminjaman? status,
    String? catatanPenolakan,
    DateTime? dibuatPada,
    DateTime? updatedAt,
    Pengguna? peminjam,
    Pengguna? petugas,
  }) {
    return Peminjaman(
      id: id ?? this.id,
      kodePeminjaman: kodePeminjaman ?? this.kodePeminjaman,
      peminjamId: peminjamId ?? this.peminjamId,
      petugasId: petugasId ?? this.petugasId,
      tanggalPinjam: tanggalPinjam ?? this.tanggalPinjam,
      tanggalJatuhTempo: tanggalJatuhTempo ?? this.tanggalJatuhTempo,
      totalDenda: totalDenda ?? this.totalDenda,
      status: status ?? this.status,
      catatanPenolakan: catatanPenolakan ?? this.catatanPenolakan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      updatedAt: updatedAt ?? this.updatedAt,
      peminjam: peminjam ?? this.peminjam,
      petugas: petugas ?? this.petugas,
    );
  }
}
