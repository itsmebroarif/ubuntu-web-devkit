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

spinner() {
    local pid=$1
    local delay=0.1
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    
    while kill -0 $pid 2>/dev/null; do
        for frame in "${frames[@]}"; do
            echo -ne "\r${CYAN}${frame}${NC} ${BOLD}Sedang memproses...${NC}"
            sleep $delay
        done
    done
    echo -ne "\r"
}

# =====================================================
# UTILITY FUNCTIONS
# =====================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Script ini memerlukan privilese sudo. Jalankan dengan 'sudo bash $0'"
        exit 1
    fi
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
    echo -e "  2. Gunakan ${GREEN}selectphp${NC} untuk switch PHP version"
    echo -e "  3. Gunakan ${GREEN}start-adminer${NC} untuk akses database"
    echo ""
    echo -e "${MAGENTA}${BOLD}Tips:${NC}"
    echo -e "  • Edit dengan Neovim: ${GREEN}nvim <file>${NC}"
    echo -e "  • Edit dengan Micro: ${GREEN}micro <file>${NC}"
    echo -e "  • Split terminal multiplexer: ${GREEN}tmux${NC}"
    echo -e "  • Start PHP server: ${GREEN}phpserve${NC}"
    echo -e "  • Lihat aliases: ${GREEN}alias${NC}"
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
  ║      Modern Development Environment    ║
  ╚═══════════════════════════════════════╝
BANNER
    echo -e "${NC}\n"
    
    log_info "Versi: 2.0 | Mode: Production Ready"
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
    
    show_summary
}

# =====================================================
# ENTRY POINT
# =====================================================

trap 'log_error "Script dihentikan"; exit 130' INT TERM

main "$@"
