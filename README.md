# 🚀 Linux Starter Kit - Development Environment Setup

## 📖 General Information
Dokumen ini merupakan panduan teknis resmi untuk skrip otomatisasi *Starter Kit* lingkungan pengembangan (*development environment*). Skrip ini dirancang khusus untuk melakukan konfigurasi menyeluruh pada sistem operasi **Ubuntu 24.04 LTS Desktop**, guna menciptakan ruang kerja pemrograman yang modern, bersih, cepat, dan siap produksi (*production-ready*).

Dengan mengeksekusi skrip ini, seluruh ekosistem dasar yang dibutuhkan untuk pengembangan web modern—mulai dari manajemen versi PHP tingkat lanjut, pustaka JavaScript terbaru, sistem basis data lokal, manajemen database berbasis web, hingga peralatan berbasis kecerdasan buatan (*AI CLI Tools*)—akan terkonfigurasi secara otomatis tanpa memerlukan intervensi manual.

---

## 🚀 Installation & Usage Guide

### Langkah 1: Persiapan Berkas Skrip
Salin blok kode skrip di atas, lalu buat berkas baru bernama `setup.sh` di lingkungan Linux lokal Anda dan tempel isinya di sana.

### Langkah 2: Memberikan Izin Eksekusi
Buka aplikasi Terminal, arahkan navigasi ke tempat berkas tersebut berada, lalu ketik perintah berikut:

```bash
chmod +x setup.sh
```

### Langkah 3: Menjalankan Instalasi
Eksekusi instalasi otomatis dengan perintah berikut:

```bash
./setup.sh
```
*Proses ini berjalan sepenuhnya non-interaktif tanpa memerlukan konfirmasi tambahan di tengah proses.*

### Langkah 4: Memuat Konfigurasi Baru
Setelah skrip selesai memunculkan baris sukses, muat ulang konfigurasi terminal shell Anda agar pintasan (*aliases*) dan NVM aktif:

```bash
source ~/.bashrc
```
*Sekarang ruang kerja pengembangan Anda sudah sepenuhnya siap digunakan untuk produktivitas kerja harian!*

---

## 🛠️ Technical Specifications & Architecture

### 1. Multi-Version PHP Management
Skrip memanfaatkan repositori **PPA Ondrej Sury** untuk memasang berbagai versi runtime PHP secara paralel (mulai dari versi warisan `7.4` hingga versi mutakhir `8.5`). Melalui utilitas `update-alternatives` bawaan Linux, pengembang dapat berpindah versi PHP secara instan di tingkat sistem global demi mendukung kebutuhan proyek legacy maupun modern.

### 2. Node.js Ecosystem via NVM
Untuk menghindari konflik izin akses (*permission errors*) yang sering terjadi pada instalasi pustaka global melalui `apt`, lingkungan JavaScript dikelola menggunakan **NVM (Node Version Manager)**. NVM mengisolasi instalasi Node.js dan NPM di tingkat *user space* (`~/.nvm`) dan secara otomatis mengunduh versi LTS terbaru.

### 3. Database & Web Management
Sistem basis data menggunakan **MySQL Server** lokal yang dikelola langsung di bawah sistem *systemd* Ubuntu. Mengingat lingkungan ini diperuntukkan sebagai ruang kerja lokal (*development*), hak akses `root` dikonfigurasi tanpa kata sandi (*blank password*) menggunakan metode autentikasi `mysql_native_password` agar kompatibel dengan pustaka ORM seperti Laravel Eloquent dan manajer basis data **Adminer** bergaya *Dark Theme*.

### 4. Interactive Launcher (arif-it)
Menyediakan antarmuka *Text User Interface* (TUI) interaktif bergaya Laragon menggunakan `whiptail`. Launcher ini memudahkan pengguna untuk mengelola service (start/stop MySQL), memeriksa versi *stack* teknologi, membuka sesi terminal baru via `tmux`, dan menjalankan *local web server* PHP secara instan.

---

## 📊 Installed Components & Stack Table

Berikut adalah daftar komponen, perkakas, dan manajer paket yang terpasang melalui skrip ini:

| Kategori | Komponen / Pustaka | Cakupan Versi | Deskripsi & Fungsi |
| :--- | :--- | :--- | :--- |
| **Core Utilities** | `curl`, `wget`, `unzip`, `gnupg`, `whiptail` | Latest Stable | Dependensi dasar Linux untuk manajemen berkas, transfer data, dan pembuatan UI terminal. |
| **Runtime Backend** | `PHP` | 7.4, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5 | Pemasangan multi-versi PHP lengkap dengan ekstensi esensial (`mysql`, `xml`, `mbstring`, `zip`, dll). |
| **Package Manager (BE)** | `Composer` | Latest Stable | Manajer dependensi resmi untuk proyek berbasis PHP / Laravel. |
| **Version Manager (FE)** | `NVM (Node Version Manager)` | v0.39.7+ | Pengelola lingkungan runtime Node.js dan NPM di tingkat *user space*. |
| **Runtime Frontend** | `Node.js & NPM` | Latest LTS Version | Mesin eksekusi JavaScript sisi server untuk kebutuhan *build tools* frontend. |
| **Database Server** | `MySQL Server` | v8.x (Native Ubuntu 24.04) | Sistem manajemen basis data relasional lokal, diatur dengan *user* `root` tanpa *password*. |
| **Database Client** | `Adminer` | Latest Stable (Dark Theme) | Alternatif phpMyAdmin yang jauh lebih ringan, dikonfigurasi satu berkas dengan tema gelap. |
| **AI CLI Tools** | `OpenCode` & `Antigravity-cli` | Global NPM Package | Peralatan antarmuka baris perintah berbasis AI untuk membantu proses *coding* cepat. |
| **Text Editor (TUI)** | `Neovim` (`nvim`) | Latest Stable | Editor teks berbasis terminal tingkat lanjut untuk kebutuhan *code editing* tingkat tinggi. |
| **Text Editor (TUI)** | `Micro` | Latest Stable | Editor terminal modern yang mudah digunakan dengan *feel* dan *keybinding* mirip Sublime Text. |
| **Multiplexer** | `Tmux` | Latest Stable | Terminal multiplexer untuk mengelola banyak sesi dan jendela dalam satu konsol. |
| **Launcher** | `arif-it` | v1.0 | Skrip *launcher* TUI kustom yang berfungsi layaknya Laragon *control panel*. |

---

## ⌨️ Custom Aliases & Dev Menu Commands

Skrip secara otomatis menyuntikkan beberapa perintah pintasan (*aliases*) ke dalam berkas `~/.bashrc` Anda untuk mempercepat alur kerja harian:

*   **`arif-it`** : Membuka TUI Launcher bergaya Laragon untuk mengontrol *environment* dengan mudah.
*   **`phplist`** : Menampilkan seluruh daftar versi PHP yang terinstal di sistem Ubuntu Anda.
*   **`selectphp`** : Membuka menu interaktif untuk memilih versi PHP global yang aktif.
*   **`phpcurrent`** : Memeriksa versi PHP yang sedang aktif saat ini.
*   **`phpserve`** : Menjalankan *built-in web server* PHP di port 8000.
*   **`start-adminer`** : Menjalankan *built-in web server* PHP untuk membuka Adminer secara instan di peramban pada alamat `http://localhost:8080`.
*   **`mysql-start` / `mysql-stop` / `mysql-status`** : Perintah cepat untuk mengelola *service* MySQL lokal.
*   **`npm-update` / `npm-list`** : Perintah utilitas untuk mengelola *package* global NPM.

---

## 📜 Automation Script (`setup.sh`)

Berikut adalah skrip bash lengkap yang dieksekusi oleh lingkungan ini. Skrip ini sudah dioptimalkan agar berjalan dengan dukungan *error handling*, tampilan *logging* berwarna, dan instalasi *launcher* interaktif.

```bash
#!/bin/bash

# =====================================================
# Linux Starter Kit - Installation Script (Modernized)
# =====================================================

set -euo pipefail

# =====================================================
# COLOR & STYLING
# =====================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'

# =====================================================
# LOGGING FUNCTIONS
# =====================================================

log_info() {
    echo -e "${CYAN}ℹ${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $*"
}

log_header() {
    echo ""
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}  $*${NC}"
    echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

log_section() {
    echo -e "\n${MAGENTA}▶${NC} ${BOLD}$*${NC}"
}

log_step() {
    echo -e "  ${CYAN}→${NC} $*"
}

# =====================================================
# UTILITY FUNCTIONS
# =====================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_command() {
    if ! command_exists "$1"; then
        log_error "Perintah '$1' tidak ditemukan. Instalasi tidak dapat dilanjutkan."
        exit 1
    fi
}

user_confirm() {
    local prompt="$1"
    local response
    
    while true; do
        echo -ne "${YELLOW}?${NC} ${BOLD}${prompt}${NC} ${CYAN}[y/n]${NC} "
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY]) return 0 ;;
            [nN][oO]|[nN]) return 1 ;;
            *) log_warning "Silakan masukkan 'y' atau 'n'" ;;
        esac
    done
}

execute_cmd() {
    local description="$1"
    shift
    
    log_step "$description"
    
    if "$@" > /tmp/install_log.tmp 2>&1; then
        log_success "$description"
        return 0
    else
        log_error "Gagal: $description"
        log_step "Detail error:"
        tail -n 5 /tmp/install_log.tmp | sed 's/^/    /'
        return 1
    fi
}

# =====================================================
# INSTALLATION CHECKS
# =====================================================

check_php_version() {
    if command_exists php; then
        php -v | head -n 1
    else
        echo "Tidak terinstal"
    fi
}

check_node_version() {
    if command_exists node; then
        node --version
    else
        echo "Tidak terinstal"
    fi
}

check_mysql_version() {
    if command_exists mysql; then
        mysql --version
    else
        echo "Tidak terinstal"
    fi
}

# =====================================================
# INSTALLATION FUNCTIONS
# =====================================================

install_dependencies() {
    log_header "📦 STEP 1: Repository & Dependensi Dasar"
    
    log_section "Memperbarui package manager..."
    execute_cmd "Update repository" apt update
    
    log_section "Menginstal dependensi dasar..."
    local packages=(
        "software-properties-common"
        "ca-certificates"
        "apt-transport-https"
        "lsb-release"
        "curl"
        "gnupg"
        "unzip"
        "wget"
        "git"
        "build-essential"
        "whiptail" # Komponen untuk UI Menu
    )
    
    execute_cmd "Instal ${#packages[@]} paket dependensi" \
        apt install -y "${packages[@]}"
}

install_php() {
    log_header "🐘 STEP 2: PHP Setup (Multiple Versions)"
    
    log_section "Menambahkan repository PHP Ondrej..."
    execute_cmd "Tambah PPA Ondrej" add-apt-repository ppa:ondrej/php -y
    execute_cmd "Update repository" apt update
    
    log_section "Menginstal PHP versi: 7.4, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5..."
    
    local php_versions=("7.4" "8.0" "8.1" "8.2" "8.3" "8.4" "8.5")
    local php_packages=()
    
    for version in "${php_versions[@]}"; do
        php_packages+=(
            "php${version}"
            "php${version}-cli"
            "php${version}-common"
            "php${version}-mysql"
            "php${version}-xml"
            "php${version}-mbstring"
            "php${version}-curl"
            "php${version}-zip"
            "php${version}-bcmath"
            "php${version}-gd"
            "php${version}-intl"
        )
    done
    
    execute_cmd "Instal semua versi PHP" apt install -y "${php_packages[@]}"
    
    log_success "PHP versi: $(php -v | head -n 1 | awk '{print $2}')"
}

install_composer() {
    log_header "🎼 STEP 3: Composer Installation"
    
    if command_exists composer; then
        log_warning "Composer sudah terinstal: $(composer --version)"
        return 0
    fi
    
    log_section "Menginstal Composer..."
    execute_cmd "Download & instal Composer" apt install -y composer
    
    log_success "Composer versi: $(composer --version | awk '{print $3}')"
}

install_nodejs() {
    log_header "🟢 STEP 4: Node.js & NPM (via NVM)"
    
    local nvm_dir="${HOME}/.nvm"
    
    if [[ -d "$nvm_dir" ]]; then
        log_warning "NVM sudah terinstal"
    else
        log_section "Mengunduh & menginstal NVM..."
        
        {
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        } > /tmp/nvm_install.tmp 2>&1
        
        if [[ -d "$nvm_dir" ]]; then
            log_success "NVM berhasil diinstal"
        else
            log_error "Gagal menginstal NVM"
            return 1
        fi
    fi
    
    log_section "Setup Node.js LTS..."
    
    export NVM_DIR="$nvm_dir"
    # shellcheck source=/dev/null
    [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
    
    if command_exists nvm; then
        execute_cmd "Instal Node.js LTS" nvm install --lts
        nvm use --lts
        log_success "Node.js versi: $(node --version)"
        log_success "NPM versi: $(npm --version)"
    else
        log_error "NVM tidak tersedia di sesi ini. Jalankan: source ~/.bashrc"
    fi
}

install_mysql() {
    log_header "🐬 STEP 5: MySQL Server"
    
    if command_exists mysql; then
        log_warning "MySQL sudah terinstal: $(mysql --version)"
        return 0
    fi
    
    log_section "Menginstal MySQL Server..."
    execute_cmd "Instal MySQL" apt install -y mysql-server
    
    log_section "Memulai MySQL service..."
    execute_cmd "Start MySQL" systemctl start mysql
    
    log_section "Mengkonfigurasi user root (tanpa password)..."
    execute_cmd "Konfigurasi MySQL" \
        mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; FLUSH PRIVILEGES;"
    
    log_success "MySQL berhasil dikonfigurasi"
}

install_adminer() {
    log_header "🗄️ STEP 6: Adminer Database Manager"
    
    local adminer_path="/usr/share/adminer"
    
    log_section "Mengunduh Adminer..."
    
    mkdir -p "$adminer_path"
    
    execute_cmd "Download adminer.php" \
        wget "https://www.adminer.org/latest.php" -O "$adminer_path/adminer.php"
    
    execute_cmd "Download dark theme CSS" \
        wget "https://raw.githubusercontent.com/pepa-linha/Adminer-Design-Dark/master/adminer.css" -O "$adminer_path/adminer.css"
    
    log_success "Adminer diinstal di: $adminer_path"
}

install_ai_tools() {
    log_header "🤖 STEP 7: AI CLI Tools"
    
    if ! command_exists npm; then
        log_warning "NPM tidak tersedia. Lewati instalasi AI tools."
        return 0
    fi
    
    log_section "Menginstal global npm packages..."
    
    execute_cmd "Instal OpenCode" npm install -g opencode 2>/dev/null || log_warning "OpenCode gagal diinstal"
    execute_cmd "Instal Antigravity CLI" npm install -g antigravity-cli 2>/dev/null || log_warning "Antigravity CLI gagal diinstal"
}

install_neovim() {
    log_header "📝 STEP 8: Neovim Text Editor"
    
    if command_exists nvim; then
        log_warning "Neovim sudah terinstal: $(nvim --version | head -n 1)"
        return 0
    fi
    
    log_section "Menginstal Neovim..."
    execute_cmd "Instal Neovim" apt install -y neovim
    
    log_success "Neovim berhasil diinstal"
}

install_micro() {
    log_header "📝 STEP 9: Micro Text Editor (Modern TUI)"
    
    if command_exists micro; then
        log_warning "Micro sudah terinstal: $(micro --version)"
        return 0
    fi
    
    log_section "Menginstal Micro editor..."
    
    {
        curl https://getmic.ro | bash
        mv micro /usr/local/bin/
    } > /tmp/micro_install.tmp 2>&1
    
    if command_exists micro; then
        log_success "Micro berhasil diinstal"
    else
        log_error "Gagal menginstal Micro"
    fi
}

install_tmux() {
    log_header "🪟 STEP 10: Tmux Terminal Multiplexer"
    
    if command_exists tmux; then
        log_warning "Tmux sudah terinstal: $(tmux -V)"
        return 0
    fi
    
    log_section "Menginstal Tmux..."
    execute_cmd "Instal Tmux" apt install -y tmux
    
    log_success "Tmux berhasil diinstal"
}

setup_aliases() {
    log_header "🛠️ STEP 11: Development Aliases & Functions"
    
    log_section "Menambahkan aliases ke ~/.bashrc..."
    
    cat << 'ALIASES_EOF' >> ~/.bashrc

# ========== PHP DEV MENU ==========
alias phplist='update-alternatives --display php'
alias selectphp='sudo update-alternatives --config php'
alias phpcurrent='php -v'
alias phpserve='php -S localhost:8000'

# ========== ADMINER ==========
alias start-adminer='echo "🌐 Membuka Adminer di http://localhost:8080..." && php -S localhost:8080 -t /usr/share/adminer'

# ========== MYSQL ==========
alias mysql-start='sudo systemctl start mysql && echo "✓ MySQL started"'
alias mysql-stop='sudo systemctl stop mysql && echo "✓ MySQL stopped"'
alias mysql-status='sudo systemctl status mysql'

# ========== NODE ==========
alias npm-update='npm update -g'
alias npm-list='npm list -g --depth=0'

# ========== DEV SHORTCUTS ==========
alias editbashrc='micro ~/.bashrc'
alias sourcebashrc='source ~/.bashrc && echo "✓ Bashrc reloaded"'

# ========== SYSTEM ==========
alias ll='ls -lAh'
alias clear-cache='sudo apt clean && sudo apt autoclean'

ALIASES_EOF
    
    log_success "Custom aliases berhasil ditambahkan"
}

setup_arif_it_launcher() {
    log_header "🚀 STEP 12: Creating arif-it TUI Launcher"
    
    log_section "Membangun script launcher Laragon-style..."
    
    cat << 'LAUNCHER_EOF' > /usr/local/bin/arif-it
#!/bin/bash

# Memastikan environment NVM termuat jika dibutuhkan Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

while true; do
    CHOICE=$(whiptail --title "🚀 ARIF-IT WORKSTATION LAUNCHER" --menu "Laragon Alternative Menu\nPilih aksi pengembangan:" 22 65 12 \
        "1" "🐘 Cek Status & Versi (PHP, Node, MySQL)" \
        "2" "▶ Start MySQL Service" \
        "3" "⏹ Stop MySQL Service" \
        "4" "🗄️ Buka Adminer (Port 8080)" \
        "5" "⚡ Start PHP Dev Server (Pilih Folder)" \
        "6" "🔄 Switch Versi PHP (Global)" \
        "7" "🪟 Buka Sesi Tmux Baru" \
        "0" "❌ Keluar" 3>&1 1>&2 2>&3)

    # Exit jika tekan Cancel atau ESC
    if [ $? -ne 0 ]; then
        clear
        break
    fi

    case $CHOICE in
        1)
            PHP_VER=$(php -v | head -n 1)
            NODE_VER=$(node -v 2>/dev/null || echo "Tidak terdeteksi")
            MYSQL_STATUS=$(systemctl is-active mysql)
            whiptail --title "Status Sistem" --msgbox "PHP:\n$PHP_VER\n\nNode.js:\n$NODE_VER\n\nMySQL Service:\n$MYSQL_STATUS" 15 60
            ;;
        2)
            sudo systemctl start mysql
            whiptail --title "Sukses" --msgbox "MySQL Service berhasil di-start!" 8 45
            ;;
        3)
            sudo systemctl stop mysql
            whiptail --title "Sukses" --msgbox "MySQL Service berhasil dihentikan!" 8 45
            ;;
        4)
            echo "========================================="
            echo "🌐 Menjalankan Adminer di Port 8080"
            echo "Buka browser: http://localhost:8080"
            echo "Tekan CTRL+C untuk menghentikan server."
            echo "========================================="
            php -S localhost:8080 -t /usr/share/adminer
            ;;
        5)
            DIR=$(whiptail --title "PHP Dev Server" --inputbox "Masukkan path direktori untuk di-serve\n(Tekan OK untuk path saat ini):" 10 50 "$PWD" 3>&1 1>&2 2>&3)
            if [ $? -eq 0 ]; then
                if [ -d "$DIR" ]; then
                    echo "========================================="
                    echo "⚡ Menjalankan PHP Server di Port 8000"
                    echo "📁 Direktori: $DIR"
                    echo "Buka browser: http://localhost:8000"
                    echo "Tekan CTRL+C untuk menghentikan server."
                    echo "========================================="
                    cd "$DIR" && php -S localhost:8000
                else
                    whiptail --title "Error" --msgbox "Direktori tidak ditemukan!" 8 40
                fi
            fi
            ;;
        6)
            clear
            sudo update-alternatives --config php
            echo -e "\nTekan Enter untuk kembali ke menu utama..."
            read
            ;;
        7)
            clear
            echo "Membuka Tmux..."
            tmux
            ;;
        0)
            clear
            break
            ;;
    esac
done
LAUNCHER_EOF

    execute_cmd "Set permission executable untuk arif-it" chmod +x /usr/local/bin/arif-it
    log_success "Launcher 'arif-it' siap digunakan!"
}

show_summary() {
    log_header "✨ INSTALASI SELESAI!"
    
    echo -e "${GREEN}${BOLD}Ringkasan Instalasi:${NC}\n"
    
    echo -e "  ${CYAN}PHP:${NC} $(check_php_version)"
    echo -e "  ${CYAN}Composer:${NC} $(command_exists composer && composer --version | awk '{print $3}' || echo 'Tidak terinstal')"
    echo -e "  ${CYAN}Node.js:${NC} $(check_node_version)"
    echo -e "  ${CYAN}npm:${NC} $(command_exists npm && npm --version || echo 'Tidak terinstal')"
    echo -e "  ${CYAN}MySQL:${NC} $(check_mysql_version)"
    echo -e "  ${CYAN}Neovim:${NC} $(command_exists nvim && nvim --version | head -n 1 || echo 'Tidak terinstal')"
    echo -e "  ${CYAN}Micro:${NC} $(command_exists micro && micro --version || echo 'Tidak terinstal')"
    echo -e "  ${CYAN}Tmux:${NC} $(command_exists tmux && tmux -V || echo 'Tidak terinstal')"
    
    echo ""
    echo -e "${YELLOW}${BOLD}Langkah Selanjutnya:${NC}"
    echo -e "  1. ${CYAN}source ~/.bashrc${NC} (atau restart terminal)"
    echo -e "  2. Ketik perintah sakti: ${GREEN}${BOLD}arif-it${NC} untuk membuka TUI Launcher"
    echo ""
    echo -e "${MAGENTA}${BOLD}Tips arif-it Launcher:${NC}"
    echo -e "  • Menu ini mirip control panel Laragon."
    echo -e "  • Gunakan panah atas/bawah untuk memilih menu, Enter untuk eksekusi."
    echo -e "  • Sangat praktis untuk on/off MySQL, ganti versi PHP, & buka server lokal."
    echo ""
}

# =====================================================
# MAIN INSTALLATION FLOW
# =====================================================

main() {
    clear
    
    echo -e "${BOLD}${CYAN}"
    cat << 'BANNER'
  ╔═══════════════════════════════════════╗
  ║   🚀 Linux Starter Kit Installer 🚀   ║
  ║      Modern Development Environment   ║
  ╚═══════════════════════════════════════╝
BANNER
    echo -e "${NC}\n"
    
    log_info "Versi: 2.1 | Mode: Production Ready + TUI Launcher"
    echo ""
    
    # Checks
    require_command sudo
    
    if ! user_confirm "Lanjutkan instalasi ke sistem Anda?"; then
        log_warning "Instalasi dibatalkan"
        exit 0
    fi
    
    echo ""
    
    # Installation Steps
    install_dependencies
    install_php
    install_composer
    install_nodejs
    install_mysql
    install_adminer
    install_ai_tools
    install_neovim
    install_micro
    install_tmux
    setup_aliases
    setup_arif_it_launcher
    
    show_summary
}

# =====================================================
# ENTRY POINT
# =====================================================

trap 'log_error "Script dihentikan"; exit 130' INT TERM

main "$@"
```
