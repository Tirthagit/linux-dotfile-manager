#!/bin/bash

BACKUP_DIR="$HOME/.local/share/dotfiles_backup"

mkdir -p "$BACKUP_DIR"

echo "📂 Available backups:"

select BACKUP in "$BACKUP_DIR/"*.tar.gz; do
    if [[ -n $BACKUP ]]; then
        echo "📥 Selected: $BACKUP"
        echo "This will overwrite existing dotfiles."
        read -p "⚠️ Proceed with restore? (y/n): " confirm
        if [[ "$conirm" == "y" ]]; then
            tar -xzf "$BACKUP" -C "$HOME"
            echo "✅ Restore complete!"
        else
            echo "Restore cancelled."
        fi
        break
    else
        echo "Invalid selection. Try again!"
    fi
done



