/// Model class untuk data pengguna dari tabel public.pengguna
class Pengguna {
  final String id;
  final String nama;
  final String email;
  final bool aktif;
  final DateTime? dibuatPada;
  final String role;

  Pengguna({
    required this.id,
    required this.nama,
    required this.email,
    required this.aktif,
    this.dibuatPada,
    required this.role,
  });

  /// Factory method untuk parsing data dari Supabase
  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'] as String,
      nama: json['nama'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      aktif: json['aktif'] as bool? ?? true,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.tryParse(json['dibuat_pada'] as String)
          : null,
      role: json['role'] as String? ?? 'peminjam',
    );
  }

  /// Convert ke Map untuk update ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'aktif': aktif,
      'role': role,
    };
  }

  /// Helper untuk mendapatkan role dengan huruf kapital
  String get roleDisplay {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'petugas':
        return 'Petugas';
      case 'peminjam':
        return 'Peminjam';
      default:
        return role;
    }
  }

  /// Copy with method untuk membuat salinan dengan perubahan
  Pengguna copyWith({
    String? id,
    String? nama,
    String? email,
    bool? aktif,
    DateTime? dibuatPada,
    String? role,
  }) {
    return Pengguna(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      aktif: aktif ?? this.aktif,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      role: role ?? this.role,
    );
  }
}
