#!/bin/bash

# Go the dotfiles directory
cd "$HOME/dotfiles"

# Pull latest changes from Github repository
echo "🔄 Pulling latest changes from Github"
git pull origin main

# (Optional) Commit changes made in local Linux environment in Github repository
read -p "Do you want to push local changes to Github? [Y/n]: " push
if [[ $push ~= ^[Yy]$ ]]; then
    git add .
    echo "Enter commit message: $msg"
    git commit -m "$msg"
    git push origin main
fi