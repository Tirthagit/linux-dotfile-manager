#!/bin/bash

# ──[ Colors ]────────────────────────────────────────────────────
cyan="\e[96m"
magenta="\e[95m"
green="\e[92m"
yellow="\e[93m"
blue="\e[94m"
bold="\e[1m"
reset="\e[0m"

# ──[ ASCII Art Banner ]──────────────────────────────────────────
echo -e "${magenta}${bold}"
cat <<'EOF'
   ____        _    __ _ _
  |  _ \  ___ | |_ / _(_) | ___  ___
  | | | |/ _ \| __| |_| | |/ _ \/ __|
  | |_| | (_) | |_|  _| | |  __/\__ \
  |____/ \___/ \__|_| |_|_|\___||___/

EOF

# ──[ Description ]───────────────────────────────────────────────
echo -e "${cyan}${bold}Dotfiles${reset} ${green}– Distro-Aware Dotfiles Manager${reset}"
echo -e "${yellow}Your Linux. Your Configs. Synchronized.${reset}"

# ──[ Spinner (Simulated Loading) ]───────────────────────────────
spinner(){
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ──[ Simulated Welcome Task ]────────────────────────────────────
( sleep 2 ) & spinner
echo -e "${green}✔ Welcome check complete!${reset}"

# ──[ Prompt to Continue ]────────────────────────────────────────
echo -e ""
read -n 1 -s -r -p "👉 Press any key to continue..."
echo -e "\n"

