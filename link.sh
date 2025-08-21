#!/bin/bash

set -e

echo "🔗 Creating symlinks for dotfiles..."
echo "===================================="
echo ""

DOTFILES="$HOME/dotfiles"

# Backup existing files
backup_if_exists() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

# Create symlinks
echo "📝 Linking .zshrc..."
backup_if_exists "$HOME/.zshrc"
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"

echo "📝 Linking .gitconfig..."
backup_if_exists "$HOME/.gitconfig"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig" 2>/dev/null || true

echo "📝 Linking Karabiner config..."
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/karabiner"
ln -sf "$DOTFILES/karabiner" "$HOME/.config/karabiner" 2>/dev/null || true

echo ""
echo "✅ Symlinks created successfully!"
echo ""
echo "To apply changes, run:"
echo "  source ~/.zshrc"