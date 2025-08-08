#!/bin/bash

# scripts/backup.sh

# -------------------------------
# 🗂️ Dotfiles Backup Script
# -------------------------------
# This script backs up selected dotfiles to a timestamped archive.
# Intended for quick recovery, syncing across systems, or versioning.
# -------------------------------

# Get current timestamp in format: YYYY-MM-DD_HH-MM-SS
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Directory where backups will be stored
BACKUP_DIR="$HOME/.local/share/dotfiles-utility/dotfiles_backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "🔒 Backing up existinng dotfiles to $BACKUP_DIR"

# List of dotfiles to back up
# Add/remove paths as needed
DOTFILES_TO_BACKUP=(
    "$HOME/.bashrc"
    "$HOME/.zshrc"
    "$HOME/.vimrc"
    "$HOME/.config/nvim"
    # "$HOME/.config/kitty"
)

# Copy each dotfile to the backup directory
for FILE in "${DOTFILES_TO_BACKUP[@]}"; do
    if [ -e "$FILE" ]; then
        cp -r "$FILE" "$BACKUP_DIR/"
        echo "✔️ Backed up $FILE"
    else
        echo "⚠️ File not found (skipped): $FILE"
    fi
done

# Define the final compress archive path
$BACKUP_FILE="$BACKUP_DIR/dotfiles_backup_$timestamp.tar.gz"

echo "📦 Creating backup at: $BACKUP_FILE"

# Compress the contents of the backup directory into a .tar.gz file

tar -czf "$BACKUP_FILE" "${DOTFILES_TO_BACKUP[@]}" 2>/dev/null

# Check if the tar was successfyl (exit status 0 = success)
# `-c ensures we compress only the content (not the full path) 
# `2>/dev/null` hides warnings/errors from tar 
if [[ $? -eq 0 ]]; then
    echo "✅ Backup successful: $BACKUP_FILE"
else
    echo "❌ Backup failed"
fi