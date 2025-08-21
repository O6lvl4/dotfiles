#!/bin/bash

set -e

echo "💾 Backing up current environment..."
echo "===================================="
echo ""

# Generate Brewfile from current installation
echo "📦 Generating Brewfile from current installation..."
brew bundle dump --file=~/dotfiles/Brewfile.backup --force

echo ""
echo "✨ Backup complete!"
echo "   Backup saved to: ~/dotfiles/Brewfile.backup"
echo ""
echo "To restore from backup:"
echo "  brew bundle --file=~/dotfiles/Brewfile.backup"