# 🚀 Linux Starter Kit - Development Environment Setup

## 📖 General Information
Dokumen ini merupakan panduan teknis resmi untuk skrip otomatisasi *Starter Kit* lingkungan pengembangan (*development environment*). Skrip ini dirancang khusus untuk melakukan konfigurasi menyeluruh pada sistem operasi **Ubuntu 24.04 LTS Desktop**, guna menciptakan ruang kerja pemrograman yang modern, bersih, cepat, dan siap produksi (*production-ready*).

Dengan mengeksekusi skrip ini, seluruh ekosistem dasar yang dibutuhkan untuk pengembangan web modern—mulai dari manajemen versi PHP tingkat lanjut, pustaka JavaScript terbaru, sistem basis data lokal, manajemen database berbasis web, hingga peralatan berbasis kecerdasan buatan (*AI CLI Tools*)—akan terkonfigurasi secara otomatis tanpa memerlukan intervensi manual.

---

## 🛠️ Technical Specifications & Architecture

### 1. Multi-Version PHP Management
Skrip memanfaatkan repositori **PPA Ondrej Sury** untuk memasang berbagai versi runtime PHP secara paralel (mulai dari versi warisan `7.4` hingga versi mutakhir `8.5`). Melalui utilitas `update-alternatives` bawaan Linux, pengembang dapat berpindah versi PHP secara instan di tingkat sistem global demi mendukung kebutuhan proyek legacy maupun modern.

### 2. Node.js Ecosystem via NVM
Untuk menghindari konflik izin akses (*permission errors*) yang sering terjadi pada instalasi pustaka global melalui `apt`, lingkungan JavaScript dikelola menggunakan **NVM (Node Version Manager)**. NVM mengisolasi instalasi Node.js dan NPM di tingkat *user space* (`~/.nvm`) dan secara otomatis mengunduh versi LTS terbaru.

### 3. Database & Web Management
Sistem basis data menggunakan **MySQL Server** lokal yang dikelola langsung di bawah sistem *systemd* Ubuntu. Mengingat lingkungan ini diperuntukkan sebagai ruang kerja lokal (*development*), hak akses `root` dikonfigurasi tanpa kata sandi (*blank password*) menggunakan metode autentikasi `mysql_native_password` agar kompatibel dengan pustaka ORM seperti Laravel Eloquent dan manajer basis data **Adminer** bergaya *Dark Theme*.

---

## 📊 Installed Components & Stack Table

Berikut adalah daftar komponen, perkakas, dan manajer paket yang terpasang melalui skrip ini:

| Kategori | Komponen / Pustaka | Cakupan Versi | Deskripsi & Fungsi |
| :--- | :--- | :--- | :--- |
| **Core Utilities** | `curl`, `wget`, `unzip`, `gnupg` | Latest Stable | Dependensi dasar Linux untuk manajemen berkas dan transfer data. |
| **Runtime Backend** | `PHP` | 7.4, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5 | Pemasangan multi-versi PHP lengkap dengan ekstensi esensial (`mysql`, `xml`, `mbstring`, `zip`, dll). |
| **Package Manager (BE)** | `Composer` | Latest Stable | Manajer dependensi resmi untuk proyek berbasis PHP / Laravel. |
| **Version Manager (FE)** | `NVM (Node Version Manager)` | v0.39.7+ | Pengelola lingkungan runtime Node.js dan NPM di tingkat *user space*. |
| **Runtime Frontend** | `Node.js & NPM` | Latest LTS Version | Mesin eksekusi JavaScript sisi server untuk kebutuhan *build tools* frontend. |
| **Database Server** | `MySQL Server` | v8.x (Native Ubuntu 24.04) | Sistem manajemen basis data relasional lokal, diatur dengan *user* `root` tanpa *password*. |
| **Database Client** | `Adminer` | Latest Stable (Dark Theme) | Alternatif phpMyAdmin yang jauh lebih ringan, dikonfigurasi satu berkas dengan tema gelap. |
| **AI CLI Tools** | `OpenCode` & `Antigravity-cli` | Global NPM Package | Peralatan antarmuka baris perintah berbasis AI untuk membantu proses *coding* cepat. |
| **Text Editor (TUI)** | `Neovim` (`nvim`) | Latest Stable | Editor teks berbasis terminal tingkat lanjut untuk kebutuhan *code editing* tingkat tinggi. |
| **Text Editor (TUI)** | `Micro` | Latest Stable | Editor terminal modern yang mudah digunakan dengan *feel* dan *keybinding* mirip Sublime Text. |

---

## ⌨️ Custom Aliases & Dev Menu Commands

Skrip secara otomatis menyuntikkan beberapa perintah pintasan (*aliases*) ke dalam berkas `~/.bashrc` Anda untuk mempercepat alur kerja harian:

*   **`phplist`** : Menampilkan seluruh daftar versi PHP yang terinstal di sistem Ubuntu Anda.
*   **`selectphp`** : Membuka menu interaktif untuk memilih versi PHP global yang aktif.
*   **`phpcurrent`** : Memeriksa versi PHP yang sedang aktif saat ini.
*   **`start-adminer`** : Menjalankan *built-in web server* PHP untuk membuka Adminer secara instan di peramban pada alamat `http://localhost:8080`.

---

## 📜 Automation Script (`setup.sh`)

Berikut adalah skrip bash lengkap yang dieksekusi oleh lingkungan ini. Skrip ini sudah dioptimalkan agar berjalan secara non-interaktif pada Ubuntu 24.04 Desktop:

```bash
#!/bin/bash

# Skrip langsung berhenti jika ada satu perintah yang eror
set -e

echo "🚀 Memulai instalasi Linux Starter Kit (Optimized for Ubuntu 24.04 Desktop)..."

# ==========================================
# 1. REPO UPDATER & DEPENDENCIES
# ==========================================
echo "📦 Memperbarui Repository & Menginstal Dependensi Dasar..."
sudo apt update
sudo apt install -y software-properties-common ca-certificates apt-transport-https lsb-release curl gnupg unzip wget

# ==========================================
# 2. PHP SETUP (Ondrej PPA)
# ==========================================
echo "🐘 Menambahkan PPA Ondrej untuk PHP..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

echo "🐘 Menginstal berbagai versi PHP dan ekstensinya..."
sudo apt install -y \
php7.4 php7.4-cli php7.4-common php7.4-mysql php7.4-xml php7.4-mbstring php7.4-curl php7.4-zip php7.4-bcmath php7.4-gd \
php8.0 php8.0-cli php8.0-common php8.0-mysql php8.0-xml php8.0-mbstring php8.0-curl php8.0-zip php8.0-bcmath php8.0-gd \
php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-bcmath php8.1-gd \
php8.2 php8.2-cli php8.2-common php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-bcmath php8.2-gd \
php8.3 php8.3-cli php8.3-common php8.3-mysql php8.3-xml php8.3-mbstring php8.3-curl php8.3-zip php8.3-bcmath php8.3-gd \
php8.4 php8.4-cli php8.4-common php8.4-mysql php8.4-xml php8.4-mbstring php8.4-curl php8.4-zip php8.4-bcmath php8.4-gd \
php8.5 php8.5-cli php8.5-common php8.5-mysql php8.5-xml php8.5-mbstring php8.5-curl php8.5-zip php8.5-bcmath php8.5-gd

# ==========================================
# 3. COMPOSER INSTALLATION
# ==========================================
echo "🎼 Menginstal Composer..."
sudo apt install -y composer

# ==========================================
# 4. NODE.JS & NPM VIA NVM
# ==========================================
echo "🟢 Menginstal NVM (Node Version Manager)..."
curl -o- [https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh](https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh) | bash

# Memuat NVM secara langsung ke dalam sesi skrip saat ini
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "🟢 Menginstal Node.js versi LTS..."
nvm install --lts
nvm use --lts

# ==========================================
# 5. MYSQL SERVER (Ubuntu 24.04 Native Setup)
# ==========================================
echo "🐬 Menginstal MySQL Server..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

echo "🐬 Memastikan Service MySQL Aktif & Berjalan..."
sudo systemctl enable mysql
sudo systemctl start mysql

echo "🐬 Mengonfigurasi User Root Tanpa Password (Kompatibel dengan Laravel & Adminer)..."
# Mengubah autentikasi ke mysql_native_password agar Laravel lama dan Adminer bisa masuk tanpa enkripsi sha2 yang ketat di lokal
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; FLUSH PRIVILEGES;"

# ==========================================
# 6. ADMINER SETUP
# ==========================================
echo "🗄️ Mengunduh Adminer..."
sudo mkdir -p /usr/share/adminer
sudo wget "[https://www.adminer.org/latest.php](https://www.adminer.org/latest.php)" -O /usr/share/adminer/adminer.php
sudo wget "[https://raw.githubusercontent.com/pepa-linha/Adminer-Design-Dark/master/adminer.css](https://raw.githubusercontent.com/pepa-linha/Adminer-Design-Dark/master/adminer.css)" -O /usr/share/adminer/adminer.css

# ==========================================
# 7. DEV MENU ALIASES (BASHRC CONFIG)
# ==========================================
echo "🛠️ Menambahkan Custom Aliases ke ~/.bashrc..."

if ! grep -q "Dev Menu PHP" ~/.bashrc; then
cat << 'EOF' >> ~/.bashrc

# -- Dev Menu PHP --
alias phplist='update-alternatives --display php'
alias selectphp='sudo update-alternatives --config php'
alias phpcurrent='php -v'

# -- Adminer Shortcut --
alias start-adminer='echo "🌐 Membuka Adminer di http://localhost:8080..." && php -S localhost:8080 -t /usr/share/adminer'

EOF
fi

# ==========================================
# 8. AI CLI TOOLS (OpenCode & Antigravity)
# ==========================================
echo "🤖 Menginstal AI CLI Tools global..."
npm install -g opencode antigravity-cli

# ==========================================
# 9. TEXT EDITORS (Neovim & Micro)
# ==========================================
echo "📝 Menginstal Text Editor (Neovim & Micro)..."
sudo apt install -y neovim

curl [https://getmic.ro](https://getmic.ro) | bash
sudo mv micro /usr/local/bin/

echo "✅ [SELESAI] Semua env berhasil dipasang di Ubuntu 24.04 Desktop Anda!"
echo "🔄 Langkah terakhir, jalankan perintah ini di terminal: source ~/.bashrc"
