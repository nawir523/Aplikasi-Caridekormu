# Breakdown Iterasi Pengembangan CARIDEKORMU (Fase MVP)

**Tujuan:** Memecah proses pengembangan MVP CARIDEKORMU menjadi target-target mingguan yang terukur dan dapat dicapai.

## Minggu 1: Fondasi & Autentikasi

**Fokus Utama:** Menyiapkan seluruh infrastruktur dasar dan membuat alur masuk pengguna.

### Tugas & Target:

**Backend:**
- Setup proyek Google Firebase (Authentication, Firestore, Storage, Hosting).
- Mendesain dan mengimplementasikan Struktur Koleksi Database di Firestore (users, vendors, products, bookings).
- Menyiapkan Aturan Keamanan (Security Rules) dasar untuk Firestore.

**Frontend (Proyek Utama):**
- Setup proyek Flutter, termasuk struktur folder yang modular untuk tiga peran (Penyewa, Vendor, Admin).
- Mengimplementasikan halaman Splash Screen, Login, dan Registrasi untuk Aplikasi Penyewa.

**Integrasi:**
- Menghubungkan alur Login/Registrasi dengan Firebase Authentication. Pengguna yang mendaftar berhasil akan tercatat di Firebase Auth dan koleksi users di Firestore dengan role: 'PENYEWA'.

**Hasil Akhir:** Pengguna baru dapat mendaftar dan login ke aplikasi Penyewa.

## Minggu 2: Penemuan Produk (Read-Only)

**Fokus Utama:** Memungkinkan Penyewa untuk melihat produk yang ada di platform.

### Tugas & Target:

**Backend:**
- Mengisi Firestore secara manual dengan data dummy (2-3 vendor dan 5-10 produk).

**Frontend (Aplikasi Penyewa):**
- Halaman Utama (Home) untuk daftar produk dari Firestore.
- Halaman Detail Produk.
- Halaman Profil Vendor.

**Hasil Akhir:** Penyewa dapat melihat produk dan vendor dari database secara dinamis.

## Minggu 3: Memberdayakan Vendor (CRUD Produk)

**Fokus Utama:** Fitur utama untuk Panel Vendor.

### Tugas & Target:

**Frontend (Web Vendor):**
- Halaman Login.
- Dasbor Vendor.
- Fitur CRUD Produk.

**Backend:**
- Security Rules Firestore agar hanya vendor terkait bisa mengubah datanya.

**Hasil Akhir:** Vendor bisa login dan mengelola produknya.

## Minggu 4: Kontrol & Supervisi Admin

**Fokus Utama:** Fungsi admin dasar.

### Tugas & Target:

**Frontend (Web Admin):**
- Halaman Login.
- Halaman Manajemen Vendor.
- Fungsi Approve Vendor.

**Logika Bisnis:**
- Produk hanya tampil jika vendor berstatus APPROVED.

**Hasil Akhir:** Admin bisa mengatur vendor.

## Minggu 5: Alur Booking (Frontend)

**Fokus Utama:** Antarmuka pemesanan oleh Penyewa.

### Tugas & Target:

**Frontend (Penyewa):**
- Komponen kalender.
- Logika cek ketersediaan.
- Halaman Checkout.

**Hasil Akhir:** Penyewa dapat melalui alur pemesanan hingga sebelum pembayaran.

## Minggu 6: Integrasi Pembayaran & Otomatisasi

**Fokus Utama:** Alur booking dengan pembayaran otomatis.

### Tugas & Target:

**Backend (Cloud Functions):**
- Fungsi transaksi & webhook.
- Logika otomatisasi saat pembayaran sukses.

**Frontend (Penyewa):**
- Tombol bayar dan integrasi Payment Gateway.

**Hasil Akhir:** Alur booking berfungsi end-to-end.

## Minggu 7: Laporan & Visibilitas

**Fokus Utama:** Tampilan data pesanan untuk semua pengguna.

### Tugas & Target:

**Frontend (Penyewa):**
- Halaman "Pesanan Saya".

**Frontend (Vendor):**
- Halaman "Pesanan Masuk".
- Fitur blokir tanggal manual.

**Frontend (Admin):**
- Halaman Manajemen Pesanan.

**Hasil Akhir:** Semua peran pengguna bisa melihat datanya.

## Minggu 8: Pengujian Internal & Bug Fixing

**Fokus Utama:** Stabilitas sistem.

### Tugas & Target:
- Pengujian End-to-End.
- UI/UX polish dan animasi.
- Bug fixing dan refactoring.

**Hasil Akhir:** Aplikasi stabil siap uji coba eksternal.

## Minggu 9: UAT, Peluncuran & Deployment

**Fokus Utama:** Finalisasi dan rilis.

### Tugas & Target:

**UAT:**
- Uji coba dengan vendor dan pengguna awal.

**Deployment:**
- Deploy aplikasi web ke Firebase Hosting.
- Siapkan rilis App Store & Play Store.

**Dokumentasi:**
- Panduan penggunaan untuk vendor.

**Hasil Akhir:** MVP live dan siap tersedia ke publik.
