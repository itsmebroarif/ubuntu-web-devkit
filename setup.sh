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
