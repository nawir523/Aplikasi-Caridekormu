# **Spesifikasi Kebutuhan Perangkat Lunak (SRS)**
## **Aplikasi: CARIDEKORMU**

| **Versi Dokumen** | 1.0 |
| **Status** | Draf Final |
| **Disusun Oleh** | [Munawir ihsan] |


### **1. Pendahuluan**

#### **1.1 Tujuan Dokumen**
Dokumen Spesifikasi Kebutuhan Perangkat Lunak (SRS) ini bertujuan untuk memberikan deskripsi yang detail, komprehensif, dan jelas mengenai semua kebutuhan untuk pengembangan aplikasi **CARIDEKORMU** fase MVP (Minimum Viable Product). Dokumen ini berfungsi sebagai acuan utama dan sumber kebenaran tunggal bagi seluruh pemangku kepentingan, termasuk manajer produk, desainer UI/UX, tim pengembang (developer), dan tim penjaminan kualitas (quality assurance).

#### **1.2 Ruang Lingkup (Scope)**
**CARIDEKORMU** adalah sebuah platform marketplace digital yang dirancang untuk mempertemukan penyedia jasa dekorasi (Vendor) dengan calon pelanggan (Penyewa) untuk berbagai acara, seperti pernikahan dan pertunangan.

**Fungsi utama aplikasi ini adalah:**
*   Menyediakan etalase digital bagi Vendor untuk memamerkan dan menyewakan produk dekorasinya.
*   Memudahkan Penyewa dalam mencari, membandingkan, dan memesan dekorasi sesuai kebutuhan dan anggaran.
*   Menyediakan sistem pemesanan dan pembayaran yang aman dan terstruktur.

**Manfaat utama platform ini adalah** untuk menyederhanakan proses penyewaan dekorasi yang seringkali rumit, meningkatkan visibilitas bisnis para Vendor, dan memberikan kepastian serta kemudahan bagi para Penyewa.

#### **1.3 Definisi, Akronim, dan Singkatan**
*   **SRS**: Software Requirements Specification.
*   **MVP**: Minimum Viable Product.
*   **Penyewa**: Pengguna akhir yang mencari dan menyewa dekorasi.
*   **Vendor**: Pemilik bisnis dekorasi yang mendaftarkan produknya di platform.
*   **Admin**: Pemilik atau pengelola platform CARIDEKORMU.
*   **Flutter**: Framework UI open-source dari Google untuk membangun aplikasi multi-platform dari satu basis kode.
*   **Firebase**: Platform pengembangan aplikasi dari Google yang menyediakan layanan backend, termasuk database, autentikasi, dan penyimpanan.
*   **Firestore**: Database NoSQL berbasis dokumen dari Firebase.
*   **API**: Application Programming Interface.
*   **UI/UX**: User Interface / User Experience.

#### **1.4 Referensi**
*   Dokumen Visi & Misi Produk CARIDEKORMU v1.0.
*   Standar IEEE 830-1998 – Recommended Practice for Software Requirements Specifications.

#### **1.5 Gambaran Umum Dokumen**
Dokumen ini terdiri dari 6 bab utama. **Bab 1** memberikan pendahuluan umum. **Bab 2** memberikan deskripsi umum tentang produk, pengguna, dan batasan. **Bab 3** dan **Bab 4** merinci kebutuhan fungsional dan non-fungsional sistem. **Bab 5** menjelaskan antarmuka eksternal yang dibutuhkan. **Bab 6** menyediakan diagram pendukung seperti Use Case dan Activity Diagram untuk memvisualisasikan alur sistem.

---

### **2. Deskripsi Umum**

#### **2.1 Perspektif Produk**
CARIDEKORMU adalah sebuah sistem perangkat lunak yang **baru dan berdiri sendiri (standalone)**. Sistem ini tidak menggantikan sistem yang sudah ada sebelumnya. Namun, sistem akan berinteraksi dan bergantung pada beberapa layanan pihak ketiga, seperti Payment Gateway untuk proses transaksi dan Google Maps API untuk menampilkan lokasi vendor.

#### **2.2 Fungsi Produk**
Fungsionalitas utama yang akan disediakan oleh CARIDEKORMU pada fase MVP meliputi:
*   **Manajemen Akun Pengguna:** Pendaftaran dan login untuk ketiga peran pengguna (Penyewa, Vendor, Admin).
*   **Manajemen Katalog oleh Vendor:** Vendor dapat menambah, mengubah, dan menghapus produk dekorasi mereka.
*   **Pencarian & Penemuan Produk:** Penyewa dapat mencari dan melihat detail produk dekorasi.
*   **Proses Booking & Pembayaran:** Penyewa dapat memilih tanggal, melakukan pemesanan, dan membayar melalui sistem.
*   **Manajemen Pesanan:** Vendor dapat melihat pesanan yang masuk, dan Admin dapat mengelola status semua pesanan.
*   **Manajemen Ketersediaan:** Vendor dapat mengatur kalender ketersediaan produknya.
*   **Verifikasi & Administrasi:** Admin dapat memverifikasi Vendor dan mengawasi seluruh aktivitas platform.

#### **2.3 Karakteristik Pengguna**

| Jenis Pengguna | Deskripsi & Kebutuhan Utama | Tingkat Keahlian Teknis |
| :--- | :--- | :--- |
| **Penyewa** | Calon pengantin atau perencana acara. Butuh alur yang mudah dan visual untuk mencari dan memesan dekorasi. | Rendah - Menengah |
| **Vendor** | Pemilik bisnis dekorasi. Butuh dasbor yang praktis untuk mengelola produk, harga, dan jadwal. | Rendah - Menengah |
| **Admin** | Pengelola platform CARIDEKORMU. Butuh akses penuh untuk mengelola pengguna, transaksi, dan konten. | Tinggi |

#### **2.4 Batasan Sistem**
*   Aplikasi Penyewa hanya tersedia untuk platform mobile (Android & iOS).
*   Panel Vendor dan Admin hanya tersedia dalam bentuk aplikasi web.
*   Seluruh platform membutuhkan koneksi internet aktif untuk berfungsi.
*   Sistem pembayaran sepenuhnya bergantung pada integrasi dengan Payment Gateway pihak ketiga (misal: Midtrans, Xendit).
*   Bahasa yang didukung pada fase MVP hanya Bahasa Indonesia.
*   Teknologi yang digunakan adalah Flutter untuk frontend dan Firebase untuk backend.

#### **2.5 Asumsi dan Ketergantungan**
*   **Asumsi:** Pengguna memiliki perangkat (smartphone/komputer) yang kompatibel dan pemahaman dasar dalam menggunakan aplikasi.
*   **Ketergantungan:**
    *   Ketersediaan dan performa layanan Google Firebase (Authentication, Firestore, Storage).
    *   Ketersediaan dan fungsionalitas API dari Payment Gateway yang dipilih.
    *   Kebijakan dan ketersediaan dari Google Play Store dan Apple App Store untuk distribusi aplikasi.

---

### **3. Kebutuhan Fungsional**

Bagian ini merinci fungsi sistem dari perspektif pengguna.

#### **3.1 Kebutuhan Fungsional - Penyewa**
*   **(F-PENYEWA-01) Pendaftaran Akun:**
    *   *User Story:* Sebagai pengguna baru, saya ingin bisa mendaftar akun menggunakan email dan password agar dapat mengakses fitur pemesanan.
*   **(F-PENYEWA-02) Login Akun:**
    *   *User Story:* Sebagai pengguna terdaftar, saya ingin bisa login ke akun saya untuk melihat riwayat pesanan dan melakukan pemesanan baru.
*   **(F-PENYEWA-03) Mencari Dekorasi:**
    *   *User Story:* Sebagai penyewa, saya ingin bisa mencari produk dekorasi berdasarkan nama agar cepat menemukan yang saya inginkan.
*   **(F-PENYEWA-04) Melihat Detail Dekorasi:**
    *   *User Story:* Sebagai penyewa, saya ingin bisa melihat foto, deskripsi lengkap, dan harga sebuah dekorasi untuk membuat keputusan.
*   **(F-PENYEWA-05) Melakukan Pemesanan (Booking):**
    *   *User Story:* Sebagai penyewa, saya ingin bisa memilih tanggal sewa dan melakukan pemesanan untuk produk yang saya pilih.
*   **(F-PENYEWA-06) Melakukan Pembayaran:**
    *   *User Story:* Sebagai penyewa, saya ingin bisa membayar pesanan saya dengan mudah melalui transfer bank (Virtual Account).
*   **(F-PENYEWA-07) Melihat Riwayat Pesanan:**
    *   *User Story:* Sebagai penyewa, saya ingin bisa melihat daftar dan status dari semua pesanan yang pernah saya buat.

#### **3.2 Kebutuhan Fungsional - Vendor**
*   **(F-VENDOR-01) Login ke Panel Vendor:**
    *   *User Story:* Sebagai vendor, saya ingin bisa login ke panel web khusus untuk mengelola bisnis saya di platform.
*   **(F-VENDOR-02) Mengelola Produk Dekorasi:**
    *   *User Story:* Sebagai vendor, saya ingin bisa menambah, mengedit (deskripsi, harga, foto), dan menghapus produk saya.
*   **(F-VENDOR-03) Mengelola Ketersediaan:**
    *   *User Story:* Sebagai vendor, saya ingin bisa memblokir tanggal tertentu pada kalender produk saya jika sudah dipesan di luar platform, untuk menghindari double-booking.
*   **(F-VENDOR-04) Melihat Pesanan Masuk:**
    *   *User Story:* Sebagai vendor, saya ingin bisa melihat daftar pesanan yang masuk untuk produk saya beserta detail penyewa dan tanggal acara.

#### **3.3 Kebutuhan Fungsional - Admin**
*   **(F-ADMIN-01) Login ke Panel Admin:**
    *   *User Story:* Sebagai admin, saya ingin bisa login ke panel web admin untuk mengawasi seluruh platform.
*   **(F-ADMIN-02) Mengelola Vendor:**
    *   *User Story:* Sebagai admin, saya ingin bisa melihat daftar vendor yang mendaftar dan menyetujui (approve) vendor yang valid.
*   **(F-ADMIN-03) Mengelola Pesanan:**
    *   *User Story:* Sebagai admin, saya ingin bisa melihat semua transaksi dan mengubah status pesanan (misalnya, dari "Menunggu Pembayaran" menjadi "Dikonfirmasi").

---

### **4. Kebutuhan Non-Fungsional**

| ID | Kategori | Kebutuhan |
| :--- | :--- | :--- |
| **NF-01** | **Keamanan** | - Semua komunikasi antara klien dan server harus dienkripsi menggunakan HTTPS.<br>- Password pengguna harus disimpan dalam format hash.<br>- Akses ke data dan fungsi harus dibatasi berdasarkan peran pengguna (Role-Based Access Control). |
| **NF-02** | **Kinerja** | - Waktu muat halaman utama aplikasi mobile tidak boleh lebih dari 3 detik pada koneksi 4G.<br>- Waktu muat awal aplikasi web (Vendor & Admin) tidak boleh lebih dari 5 detik.<br>- Respon sistem terhadap aksi pengguna (klik tombol) harus terasa instan (< 500ms). |
| **NF-03** | **Reliabilitas** | - Sistem ditargetkan memiliki ketersediaan (uptime) 99%.<br>- Sistem harus memiliki mekanisme pencatatan error (logging) untuk memudahkan debugging. |
| **NF-04** | **Usability** | - Antarmuka pengguna harus bersih, intuitif, dan konsisten di seluruh platform.<br>- Desain aplikasi web harus responsif agar dapat diakses dengan baik di berbagai ukuran layar desktop. |
| **NF-05** | **Maintainability** | - Kode sumber harus terstruktur secara modular (berdasarkan fitur/peran) untuk memudahkan pemeliharaan dan pengembangan di masa depan.<br>- Kode harus memiliki komentar yang memadai pada bagian-bagian yang kompleks. |

---

### **5. Antarmuka Eksternal**

#### **5.1 Antarmuka Pengguna (UI)**
Desain antarmuka pengguna (UI) dan pengalaman pengguna (UX) akan dirancang secara terpisah menggunakan tools seperti **Figma**. Desain akan mengusung gaya yang modern, bersih, dan elegan, dengan penekanan pada visual (foto produk). Mockup dan prototipe akan dilampirkan sebagai dokumen terpisah setelah disetujui.

#### **5.2 Antarmuka Perangkat Keras**
Tidak ada antarmuka perangkat keras khusus yang dibutuhkan untuk sistem ini.

#### **5.3 Antarmuka Perangkat Lunak**
Sistem akan berinteraksi dengan API eksternal berikut:
*   **Firebase SDKs**: Untuk interaksi langsung dengan layanan Firebase (Authentication, Firestore, Storage).
*   **Payment Gateway API**: Untuk memulai transaksi, memverifikasi status pembayaran, dan mengamankan proses pembayaran. Contoh: Midtrans atau Xendit.
*   **Google Maps API (Opsional untuk Fase 2)**: Untuk menampilkan lokasi vendor pada peta.

#### **5.4 Antarmuka Komunikasi**
Komunikasi antara aplikasi frontend (Flutter) dan backend (Firebase) akan menggunakan protokol standar yang disediakan oleh Firebase SDK, yang pada dasarnya berbasis HTTPS dan WebSockets untuk pembaruan real-time. Data akan ditransfer dalam format **JSON**.

---

### **6. Use Case & Diagram Pendukung**

(Catatan: Diagram di bawah ini direpresentasikan dalam bentuk teks. Visualisasi akan dibuat dalam dokumen desain).

#### **6.1 Use Case Diagram (Teks)**

*   **Aktor:** Penyewa, Vendor, Admin, Sistem, Payment Gateway.

*   **Use Cases untuk Penyewa:**
    *   `Mendaftar`
    *   `Login`
    *   `Mencari Produk`
    *   `Melihat Detail Produk`
    *   `Membuat Pesanan` (includes: `Memilih Tanggal`)
    *   `Melakukan Pembayaran` (extends: `Melihat Riwayat Pesanan`)

*   **Use Cases untuk Vendor:**
    *   `Login`
    *   `Mengelola Profil Bisnis`
    *   `Mengelola Produk` (includes: `Tambah`, `Edit`, `Hapus Produk`)
    *   `Mengelola Kalender` (includes: `Blokir Tanggal`)
    *   `Melihat Pesanan Masuk`

*   **Use Cases untuk Admin:**
    *   `Login`
    *   `Mengelola Vendor` (includes: `Verifikasi Vendor`)
    *   `Mengelola Pesanan` (includes: `Konfirmasi Pembayaran`)
    *   `Melihat Laporan Transaksi`

#### **6.2 Activity Diagram (Teks): Alur Proses Booking**
1.  **Penyewa** membuka Halaman Detail Produk.
2.  **Penyewa** memilih tanggal sewa pada kalender.
3.  **Sistem** memeriksa ketersediaan tanggal pada sub-koleksi `unavailable_dates` produk tersebut.
4.  **[Jika Tidak Tersedia]** Sistem menampilkan pesan error. Alur berakhir.
5.  **[Jika Tersedia]** Penyewa menekan tombol "Booking Sekarang".
6.  **Sistem** menampilkan halaman Checkout.
7.  **Penyewa** mengisi data diri dan alamat acara, lalu menekan "Lanjut ke Pembayaran".
8.  **Sistem** membuat dokumen baru di koleksi `bookings` dengan status `AWAITING_PAYMENT`.
9.  **Sistem** berkomunikasi dengan **Payment Gateway API** untuk membuat invoice.
10. **Sistem** menampilkan halaman instruksi pembayaran kepada **Penyewa**.
11. **Penyewa** melakukan pembayaran.
12. **Payment Gateway** mengirim notifikasi (webhook) ke **Sistem** bahwa pembayaran berhasil.
13. **Sistem** (melalui Cloud Function) memperbarui status dokumen di `bookings` menjadi `CONFIRMED`.
14. **Sistem** membuat entri baru di `products/{productId}/unavailable_dates` untuk tanggal yang dipesan.
15. Alur Selesai.

#### **6.3 Entity-Relationship Diagram (ERD) - Konseptual (Basis: Firestore)**
*   **Entitas Utama:** `Users`, `Vendors`, `Products`, `Bookings`.
*   **Relasi:**
    *   `Users` memiliki relasi **satu-ke-satu** dengan `Vendors` (hanya jika `role`-nya adalah 'VENDOR').
    *   `Vendors` memiliki relasi **satu-ke-banyak** dengan `Products`.
    *   `Users` (sebagai Penyewa) memiliki relasi **satu-ke-banyak** dengan `Bookings`.
    *   `Products` memiliki relasi **satu-ke-banyak** dengan `Bookings`.
    *   `Products` memiliki sub-koleksi `unavailable_dates`.

Struktur ini akan diimplementasikan menggunakan koleksi dan sub-koleksi di Cloud Firestore.