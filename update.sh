#!/bin/bash

set -e

echo "🔄 Updating development environment..."
echo "======================================"
echo ""

# Update Homebrew
echo "📦 Updating Homebrew..."
brew update

# Upgrade all packages
echo "📦 Upgrading packages..."
brew upgrade

# Update packages from Brewfile
echo "📦 Syncing with Brewfile..."
brew bundle --file=~/dotfiles/Brewfile

# Cleanup old versions
echo "🧹 Cleaning up..."
brew cleanup

echo ""
echo "✨ Update complete!"