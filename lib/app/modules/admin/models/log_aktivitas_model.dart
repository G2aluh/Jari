/// Model untuk log aktivitas dari Supabase
class LogAktivitas {
  final String id;
  final String? penggunaId;
  final String aktivitas;
  final DateTime dibuatPada;
  final String? namaPengguna;

  LogAktivitas({
    required this.id,
    this.penggunaId,
    required this.aktivitas,
    required this.dibuatPada,
    this.namaPengguna,
  });

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    // Handle nested pengguna object
    String? nama;
    if (json['pengguna'] != null && json['pengguna'] is Map) {
      nama = json['pengguna']['nama'] as String?;
    }

    return LogAktivitas(
      id: json['id'] as String,
      penggunaId: json['pengguna_id'] as String?,
      aktivitas: json['aktivitas'] as String,
      dibuatPada: DateTime.parse(json['dibuat_pada'] as String),
      namaPengguna: nama ?? 'System',
    );
  }

  /// Format tanggal untuk ditampilkan
  String get tanggalFormatted {
    final day = dibuatPada.day.toString().padLeft(2, '0');
    final month = dibuatPada.month.toString().padLeft(2, '0');
    final year = dibuatPada.year;
    final hour = dibuatPada.hour.toString().padLeft(2, '0');
    final minute = dibuatPada.minute.toString().padLeft(2, '0');
    return '$day/$month/$year, $hour:$minute';
  }
}
