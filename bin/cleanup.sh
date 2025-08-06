#!/usr/bin/env bash

BACKUP_DIR="$HOME/.local/share/dotfiles_backup"

set -eou pipefail

echo "🔁 Cleaning up dotfiles project..."

# Clean logs
echo "🧹 Removing logs..."
rm -rf "$HOME/.local/share/dotfiles/log/*"

# Clean Docker containers and volumes (optional)
echo "🐳 Removing Docker containers and volumes..."
docker rm -f $(docker ps -aq) 2>/dev/null || true
docker volume prune -f

# Clean build/tmp/cache folders (if any)
echo "🗑️ Removing .cache, .tmp, .DS_Store..."
find . -type d -name ".tmp" -exec rm -rf {} +
find . -type d -name ".cache" -exec rm -rf {} +
find . -name "DS_Store" -delete

# Cleanup old backup files
echo "🗂️ Cleaning old backup files"
rm -rf "$BACKUP_DIR/*"

echo "✅ Done cleaning up!"