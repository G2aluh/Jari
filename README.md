# JARI - Aplikasi Peminjaman Alat

Aplikasi peminjaman alat berbasis Flutter dengan backend Supabase.

## 🚀 Teknologi yang Digunakan

- **Flutter** - Framework UI cross-platform
- **GetX** - State management & routing
- **Supabase** - Backend (Database PostgreSQL & Authentication)
- **Google Fonts** - Typography (Urbanist)

## 👥 Role User

| Role | Akses |
|------|-------|
| **Admin** | Kelola pengguna, alat, kategori, peminjaman, pengembalian, log aktivitas, settings |
| **Petugas** | Verifikasi peminjaman, monitor pengembalian, generate laporan |
| **Peminjam** | Lihat alat, ajukan peminjaman, riwayat, pengembalian |

## 📁 Struktur Project

```
lib/
├── main.dart                    # Entry point aplikasi
├── app/
│   ├── core/                    # Utilities & Theme
│   │   ├── theme/              # Colors, text styles
│   │   ├── values/             # Constants, assets, strings
│   │   ├── widgets/            # Reusable widgets (button, dialog, textfield)
│   │   └── utils/              # Helper functions
│   ├── modules/
│   │   ├── admin/              # Fitur Admin
│   │   │   ├── controllers/    # Logic & state management
│   │   │   ├── models/         # Data models (Alat, Peminjaman, dll)
│   │   │   ├── views/          # UI pages
│   │   │   └── widgets/        # Admin-specific widgets
│   │   ├── petugas/            # Fitur Petugas
│   │   ├── peminjam/           # Fitur Peminjam
│   │   ├── auth/               # Login & Authentication
│   │   ├── peminjaman/         # Views peminjaman per role
│   │   ├── kategori/           # Data kategori
│   │   ├── laporan/            # Fitur laporan
│   │   └── alat/               # Data alat (dummy)
│   ├── routes/                  # Routing (app_pages, app_routes)
│   └── widgets/                 # Shared widgets
```

## ▶️ Cara Menjalankan

1. **Setup Environment**
   ```bash
   # Copy .env.example ke .env dan isi kredensial Supabase
   cp .env.example .env
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Aplikasi**
   ```bash
   flutter run
   ```

## 📊 Alur Aplikasi

```
Login → [Cek Role] → Dashboard sesuai role → Fitur-fitur
         │
         ├─ Admin → Admin Dashboard → Kelola data
         ├─ Petugas → Petugas Dashboard → Verifikasi & monitor
         └─ Peminjam → Peminjam Dashboard → Pinjam alat
```

## 📝 Routes

| Route | Halaman |
|-------|---------|
| `/login` | Halaman login |
| `/admin-dashboard` | Dashboard admin |
| `/petugas-dashboard` | Dashboard petugas |
| `/peminjam-dashboard` | Dashboard peminjam |

Lihat file `app/routes/app_routes.dart` untuk daftar lengkap routes.
