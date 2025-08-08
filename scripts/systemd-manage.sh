#!/bin/bash

# systemctl --user "$@"
set -e

# -----------------------------
# 📋 SYSTEMD SERVICE MANAGER
# -----------------------------
# Controls dotfiles-backup and dotfiles-sync services/timers
# Flags:
#   --status [all|backup|sync]
#   --start [all|backup|sync]
#   --stop [all|backup|sync]
#   --restart [all|backup|sync]
#   --disable [all|backup|sync]
#   No flags -> Interactive menu

USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
BOLD="\033[1m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

SERVICES=(dotfiles-backup dotfiles-sync)

# -----------------------------
# FUNCTIONS
# -----------------------------

show_help() {
    echo -e "${CYAN}Usage:${NC} ./systemd-manage.sh [--status|--start|--stop|--restart|--disable] [all|backup|sync]"
    echo "No flags -> Interactive menu"
}

resolve_targets() {
    local target="$1"
    local resolved=()
    case "$target" in
        all|"")
            resolved=("${SERVICES[@]}")
        ;;
        backup)
            resolved=("dotfiles-backup")
        ;;
        sync)
            resolved=("dotfiles-sync")
        ;;
        *)
            echo -e "${RED}❌ Unknown target: $target${NC}" >&2
            exit 1
        ;;
    esac
    echo "${resolved[@]}"
}

perform_action() {
    local action="$1"
    local target="$2"
    local units
    units=$(resolve_targets "$target")
    
    for svc in $units; do
        case "$action" in
            status)
                echo -e "\n${BOLD}🔍 Status: $svc.timer${NC}"
                systemctl --user status "$svc.timer" --no-pager || true
            ;;
            start)
                echo -e "${CYAN}▶ Starting $svc.timer${NC}"
                systemctl --user start "$svc.timer"
            ;;
            stop)
                echo -e "${CYAN}⏹ Stopping $svc.timer${NC}"
                systemctl --user stop "$svc.timer"
            ;;
            restart)
                echo -e "${CYAN}🔄 Restarting $svc.timer${NC}"
                systemctl --user restart "$svc.timer"
            ;;
            disable)
                echo -e "${CYAN}🚫 Disabling $svc.timer${NC}"
                systemctl --user disable --now "$svc.timer"
            ;;
        esac
    done
    echo -e "${GREEN}✅ Action '$action' completed successfully.${NC}"
}

interactive_menu() {
    echo -e "${BOLD}Systemd Service Manager${NC}"
    echo "1) Status (all)"
    echo "2) Start (all)"
    echo "3) Stop (all)"
    echo "4) Restart (all)"
    echo "5) Disable (all)"
    echo "0) Exit"
    read -rp "Select an option: " choice
    
    case $choice in
        1) perform_action status all ;;
        2) perform_action start all ;;
        3) perform_action stop all ;;
        4) perform_action restart all ;;
        5) perform_action disable all ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
}

# -----------------------------
# MAIN LOGIC
# -----------------------------

if [[ $# -eq 0 ]]; then
    interactive_menu
else
    case "$1" in
        --status)   perform_action status "$2" ;;
        --start)    perform_action start "$2" ;;
        --stop)     perform_action stop "$2" ;;
        --restart)  perform_action restart "$2" ;;
        --disable)  perform_action disable "$2" ;;
        -h|--help)  show_help ;;
        *)
            echo -e "${RED}❌ Unknown flag: $1${NC}"
            show_help
            exit 1
        ;;
    esac
fi
