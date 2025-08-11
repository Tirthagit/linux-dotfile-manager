#!/bin/bash

set -e

# -----------------------------
# 📤 SYSTEMD UNINSTALLER SCRIPT
# -----------------------------
# Supports:
# --backup  -> Uninstall backup service and timer
# --sync    -> Unistall sync service and timer
# --all     -> Remove all dotfiles related systemd units

# Define whether unit files
USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BOLD="\033[1m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

# Define services
SERVICES=()

# Supported Units
show_help(){
    echo -e "${CYAN}Usage:${NC} ./systemd-install.sh [--backup] [--sync] [--all]"
    echo "  --backup  ->  Uninstall  backup service and timer"
    echo "  --sync    ->  Uninstall  sync service and timer"
    echo "  --all     ->  Remove both backup and sync service and timer"
    echo "  No Flags  ->  Interactive selection "
}

# Uninstall selected services
remove_unit(){
    
    local name="$1"
    echo "${CYAN}🔧 Removing $name.service and $name.timer$...{NC}"
    
    systemctl --user disable --now  "$name.service" 2>/dev/null || true
    systemctl --user disable --now  "$name.timer" 2>/dev/null || true
    
    rm -f "$USER_SYSTEMD_DIR/$name.service"
    rm -f "$USER_SYSTEMD_DIR/$name.timer"
    
    echo "${GREEN}✔️ Uninstalled $name.service and $name.timer${NC}"
}

# Handle no-flag case: prompt user
if [[ $# -eq 0 ]]; then
    
    echo -e "No option provided. Choose an option:${NC} "
    echo "1) Uninstall Backup service and timer"
    echo "2) Uninstall Sync service and timer"
    echo "3) Uninstall All"
    echo "0) Cancel"
    read -rp "Enter your choice: " choice
    
    case $choice in
        1)
            SERVICES+=(dotfiles-backup)
        ;;
        2)
            SERVICES+=(dotfiles-sync)
        ;;
        3)
            SERVICES+=(dotfiles-backup dotfiles-sync)
        ;;
        *)
            echo "Cancelled." exit 0
        ;;
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
                SERVICES+=($"{SERVICES[@]}")
            ;;
            -h|--help)
                show_help; exit 0
            ;;
            *)
                echo -e "${YELLOW}No valid flag provided"; show_help; exit 1
            ;;
        esac
    done
    
fi


for service in "${SERVICES[@]}"; do
    remove_unit "$service"
done

# Reload system user daemon
systemctl --user daemon-reload 

echo -e "${GREEN}✅ All selected units uninstalled and systemd reloaded.${NC}"
