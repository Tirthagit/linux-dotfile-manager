#!/bin/bash

set -e

source scripts/cron.sh

setup_cron_jobs

# Load dotfiles aliases
if [ -d "$HOME/dotfiles/aliases" ]; then
    for file in "$HOME/dotfiles/aliases/*.sh"; do
        [ -r "$file" ] && . "$file"
    done
fi

echo "🔍 Detecting Linux Distribution..."

# Enable Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Configurations
DOTFILES_DIR="$HOME/dotfiles"
SUPPORTTED=("ubuntu", "manjaro", "fedora", "mint", "centos")
CONFIG_DIR="$DOTFILES_DIR/config/$DISTRO_ID"

# List of Common Files
DOTFILES=(.vimrc, .bashrc, .zshrc)

# Detect Distro ID
# if [ -f /etc/os-release ]; then
#     . /etc/os-release
#     DISTRO_ID=$ID
# else
#     echo "❌ Cannot detect OS (missing /etc/os-release)"
#     exit 1;

# echo "🖥️ Detected OS: $DISTRO_ID"

# OS=""
# if grep -qi "manjaro" /etc/os-release; then
#     OS="manjaro"
# elif grep -qi "ubuntu" /etc/os-release; then
#     OS="ubuntu"
# else
#     echo "❌ Unsupported OS"
#     exit 1
# fi

# echo "Detected OS:$OS"

# echo "📦 Installing config for $OS..."


# 1️⃣ Get Distro name from argument or prompt
DISTRO="$1"

if [ -z "$DISTRO" ]; then
    echo -e "${YELLOW}No distro name provided.${NC}"
    echo -ne "Please chose your distro ${BLUE}[ubuntu/manjaro/fedora/mint/centos]${NC}: "
    read DISTRO
fi

# Lowercase the input just in case
DISTRO=$(echo "$DISTRO" | tr '[:upper:]' '[:lower:]')

# 2️⃣ Validate / Detect Distro ID
if [[ ! "${SUPPORTED[*]} " =~ " ${DISTRO} " ]]; then
    echo -e "${RED}❌ Unsupported distro: $DISTRO${NC}"
    echo -e "${YELLOW}Supported distros: ${SUPPORTED[*]}${NC}"
    exit 1
fi

echo -e "${GREEN}📦 Installing dotfiles for $DISTRO...${NC}"
CONFIG_DIR="$DOTFILES_DIR/config/$DISTRO"


# 3️⃣ Link dotfiles (with optional backup)
echo "🔗 Linking common dotfiles..."
for FILE  in "${DOTFILES[@]}"; do
    # src="$HOME/dotfiles/config/$OS/$file"
    # dest="$HOME/$file"
    
    # if [ -f "$src" ]; then
    #     ln -sf "$src" "$dest"
    #     echo "Linked $src -> $dest"
    # fi
    COMMON="$DOTFILES_DIR/$FILE"
    TARGET="$HOME/$FILE"
    
    # Backup if the files exits and is not a symlink
    if [ -f $FILE ] && [ ! -L $TARGET ]; then
        cp "$TARGET" "$TARGET.bak"
        echo -e "${YELLOW}📦 Backed up existing $FILE to $FILE.bak${NC}"
    fi
    
    # Default link
    if [ -f $COMMON ]; then
        ln -sf "$COMMON" "$TARGET"
        echo -e "${BLUE}🔗 Linked $FILE -> common version${NC}"
    fi
    
    # Override if OS specific exists
    if [ -f $CONFIG_DIR/$FILE ]; then
        ln -sf "$CONFIG_DIR/$FILE" "$TARGET"
        echo -e "${BLUE}⚠️ Overriden $FILE -> $DISTRO version${NC}"
    fi
    
done

# Optional KDE settings
if [ "$DISTRO" == "manjaro" ] && [ -f $CONFIG_DIR/.config/kdeglobals ]; then
    mkdir -p "$HOME/.config"
    ln -sf "$CONFIG_DIR/.config/kdeglobals" "$HOME/.config/kdeglobals"
    echo -e "${BLUE}🎨 Kde config linked and applied for Manjaro."
fi

# 5️⃣ Done!
echo -e "${GREEN}🎉✅ Done! All dotfiles installed successfully for {$DISTRO}!${NC}"
