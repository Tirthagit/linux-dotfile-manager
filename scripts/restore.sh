#!/bin/bash

BACKUP_DIR="$HOME/.local/share/dotfiles_backup"

mkdir -p "$BACKUP_DIR"

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "❌ Backup directory does not exist: $BACKUP_DIR"
    exit 1
fi

# Function to restore from latest backup (same as previous)
restore_latest(){
    # Check if the directory exists and contains any .tar.gz file
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR/*.tar.gz 2>/dev/null" | head -n 1)
    
    if [[ -z "$LATEST_BACKUP" ]]; then
        echo "❌ No backups found in $BACKUP_DIR"
        exit 1
    fi
    
    echo "📥 Latest backup found: $LATEST_BACKUP"
    echo "⚠️ This will overwrite existing backups in your home directory!"
    
    read -p "⚠️ Proceed with restore? (y/n): " confirm
    if [[ "$conirm" == "y" ]]; then
        tar -xzf "$LATEST_BACKUP" -C "$HOME"
        echo "✅ Restore complete!"
    else
        echo "❌ Restore cancelled."
    fi
}

# Function to
restore_interactive(){
    echo "📂 Available backups:"
    
    select BACKUP in "$BACKUP_DIR/*.tar.gz"; do
        if [[ -z "$BACKUP" ]]; then
            echo "Selected backup: $BACKUP"
            echo "⚠️ This will overwrite existing dotfiles in your home directory!"
            read -p "Proceed with restore? (y/n): " confirm
            if [[ "$confirm" == "y" ]]; then
                tar -xzf "$BACKUP" -C "$HOME"
                echo "✅ Restore complete!"
            else
                echo "❌ Restore cancelled."
            fi
        else
            echo "❌ Invalid selection. Try again!"
        fi
    done
    
}

case "$1" in logic
    --latest)
        restore_latest
    ;;
    --interactive)
        restore_interactive
    ;;
    *)
    echo "Usage: "
    echo "./restore.sh --latest         # Automaticallly restore latest backup "
    echo "./restore.sh --interactive    # Choose backup manually"
    exit 1
    ;;
    *)  
esac
