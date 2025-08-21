#!/bin/bash

set -e

echo "🚀 Development Environment Setup Script"
echo "======================================"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install it first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "✅ Homebrew is installed"
echo ""

# Install Mac App Store CLI (required for mas commands)
echo "📦 Installing Mac App Store CLI..."
brew install mas

# Install all packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle --file=~/dotfiles/Brewfile

echo ""
echo "✨ Installation complete!"
echo ""
echo "Optional post-installation steps:"
echo "  1. Set iTerm2 as default terminal"
echo "  2. Configure VS Code with your preferences"
echo "  3. Set up GitHub CLI: gh auth login"
echo "  4. Configure Git:"
echo "     git config --global user.name \"Your Name\""
echo "     git config --global user.email \"your.email@example.com\""