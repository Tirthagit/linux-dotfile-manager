#!/bin/bash

set -e

# -----------------------------
# 📤 SYSTEMD INSTALLER SCRIPT
# -----------------------------
# Supports:
# --backup  -> Install backup service and timer
# --sync    -> Install sync service and timer
# --all     -> Install both backup and sync timers

# Define whether unit files
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BOLD="\033[1m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

SERVICES=()

# Supported Units
show_help(){
    echo -e "${CYAN}Usage:${NC} ./systemd-install.sh [--backup] [--sync] [--all]"
    echo "  --backup  ->  Install backup service and timer"
    echo "  --sync    ->  Install sync service and timer"
    echo "  --all     ->  Install both backup and sync service and timer"
    echo "  No Flags  ->  Interactive selection "
}

install_init(){
    
    local name="$1"
    local service_file="systemd/$name.service"
    local timer_file="systemd/$name.timer"
    
    echo -e "${CYAN}🔧 Installing $name.service and $name.timer"
    
    # Create systemd user directory if already not exists
    mkdir -p "$SYSTEMD_DIR"
    
    
    # Copy service and timer units from project dir to user's systemd user dir
    cp "$PROJECT_DIR/$service_file" "$USER_SYSTEMD_DIR/"
    cp "$PROJECT_DIR/$timer_file" "$USER_SYSTEMD_DIR/"
    
    # Enable and start the timer
    systemctl --user daemon-reload
    systemctl --reload enable --now "$name.timer"
    
    echo -e "${GREEN}✅ $name.timer started and enabled!${NC}"
    
}

if [[ $# -eq 0 ]]; then
    echo -e "No option provided. Choose an option:${NC} "
    echo "1) Install Backup service and timer"
    echo "2) Install Sync service and timer"
    echo "3) Install All"
    echo "0) Cancel"
    read -rp "Enter your choice: " choice
    
    case $choice in
        1) SERVICES+=(dotfiles-backup) ;;
        2) SERVICES+=(dotfiles-sync) ;;
        3) SERVICES+=(dotfiles-backup dotfiles-sync) ;;
        *) echo "Cancelled." exit 0 ;;
    esac
else
    for arg in "$@"; do
        case $arg in
            --backup)
                SERVICES+=(dotfiles-backup)
            ;;
            --sync)
                SERVICES+=(dotfiles-sync)
            ;;
            --all)
                SERVICES+=(dotfiles-backup dotfiles-sync)
            ;;
            -h|--help)
                echo -e "${RED}❌ Unknown flag: $arg${NC}." show_help; exit 1
            ;;
        esac
    done   
fi

for service in "${SERVICES[@]}"; do
    install_init "$service"
done

echo "${GREEN}🎉 All selected systemd services and timer installed successfully!${NC}"
