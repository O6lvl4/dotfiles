# macOS Development Environment Setup Guide

## 📅 Setup Date
- **Date**: 2024-08-21
- **macOS Version**: Darwin 22.6.0 (Ventura)
- **Architecture**: Intel Mac (x86_64)

## 🎯 Overview
This document describes a complete development environment setup for macOS, including:
- Keyboard configuration for JIS layout
- Modern language version management tools
- Development tools and applications via Homebrew
- Shell configuration with Zsh
- Git configuration and dotfiles management

## ⌨️ Keyboard Configuration (Karabiner-Elements)

### Problem Solved
- JIS physical keyboard was outputting US layout characters
- Shift+2 was outputting @ instead of " (double quote)
- Other JIS-specific keys were incorrectly mapped

### Solution
Installed and configured Karabiner-Elements with custom mapping rules.

**Key mappings implemented:**
- Shift+2 → " (double quote)
- Shift+6 → & (ampersand)
- Shift+7 → ' (single quote)
- Shift+8 → ( (left parenthesis)
- Shift+9 → ) (right parenthesis)
- @key (right of P) → @
- Option+¥ → \ (backslash)
- Other JIS-specific mappings

**Configuration file**: `~/dotfiles/karabiner/karabiner.json`

## 🛠 Package Management

### Homebrew
- **Installation path**: `/usr/local/bin/brew` (Intel Mac)
- **Version**: 4.6.4
- **Configuration**: Managed via `~/dotfiles/Brewfile`

### Installed via Homebrew
**Core Tools:**
- git, gh (GitHub CLI)
- wget, curl, tree, jq
- ripgrep, fd, bat, eza (modern replacements)
- fzf, tmux, neovim, starship

**Development Tools:**
- docker, docker-compose

**Databases:**
- postgresql@15, mysql, redis, sqlite

**GUI Applications (Casks):**
- google-chrome, firefox
- visual-studio-code, iterm2
- slack, discord, zoom
- docker, tableplus, postman
- rectangle, raycast, stats

**Fonts:**
- Hack Nerd Font (for terminal icons)

## 🔧 Language Version Management (2024 Modern Stack)

### Strategy
Instead of installing languages directly via Homebrew, we use modern version management tools for better control and project-specific versioning.

### Tools Selected

| Language | Tool | Why |
|----------|------|-----|
| **Multiple** | mise (formerly rtx) | Universal version manager, supports multiple languages |
| **Node.js** | Volta | Rust-based, fast, automatic project switching |
| **Python** | uv + mise | uv is ultra-fast package manager (Rust-based) |
| **Python Projects** | Rye | Modern Python project manager |
| **Ruby** | mise | Unified management |
| **Go** | mise | Unified management |
| **Java** | SDKMAN | Industry standard for JVM languages |
| **Rust** | rustup | Official Rust toolchain |
| **JavaScript Runtime** | Bun | Alternative fast JS runtime |

### Installation Paths
- **mise**: `~/.local/bin/mise`
- **Volta**: `~/.volta/`
- **uv**: `~/.cargo/bin/uv`
- **Rye**: `~/.rye/`
- **SDKMAN**: `~/.sdkman/`
- **Rust/Cargo**: `~/.cargo/`
- **Bun**: `~/.bun/`

### Installed Versions
- Python: 3.12.11, 3.11.13 (via mise)
- Node.js: LTS (via Volta)
- Other languages: Install on demand

## 📁 Dotfiles Structure

```
~/dotfiles/
├── .zshrc                 # Zsh configuration
├── .gitconfig            # Git configuration
├── Brewfile              # Homebrew packages
├── karabiner/            # Keyboard configuration
│   └── karabiner.json
├── setup-languages.sh    # Language tools installer
├── install.sh           # Homebrew packages installer
├── update.sh            # Update all tools
├── backup.sh            # Backup current environment
├── link.sh              # Create symlinks
├── README.md            # Basic documentation
└── SETUP_GUIDE.md       # This file
```

## 🐚 Shell Configuration (.zshrc)

### Key Features
1. **Path Configuration**
   - Homebrew (auto-detects Intel/Apple Silicon)
   - All language version managers
   - Custom bin directories

2. **Aliases**
   - Navigation shortcuts (`..`, `...`, etc.)
   - Git shortcuts (`gs`, `gc`, `gp`, etc.)
   - Docker shortcuts (`d`, `dc`, `dps`, etc.)
   - eza with icons (modern ls replacement)

3. **Functions**
   - `mkd()` - Create and enter directory
   - `proj()` - Navigate to project
   - `setup_project()` - Initialize new project with language tools
   - `update_dev()` - Update all development tools
   - `backup_dotfiles()` - Quick git backup
   - `versions()` - Show all language versions

4. **Terminal Enhancements**
   - Starship prompt (modern, fast)
   - FZF integration (fuzzy finder)
   - Zsh options for better history and completion

## 🎨 Terminal Display

### eza Configuration
- **Default**: Icons enabled (`eza --icons --group-directories-first`)
- **Aliases**:
  - `ls` → with icons
  - `ll` → detailed with icons
  - `lsn` → without icons (fallback)

### Font Requirement
- **Installed**: Hack Nerd Font
- **Purpose**: Proper icon display in terminal
- **Configuration**: Set in Terminal.app or iTerm2 preferences

## 🔄 Daily Workflow Commands

### Update Everything
```bash
update_dev  # Updates Homebrew, mise, Rust, Node tools, Python tools
```

### Check Versions
```bash
versions  # Shows all installed language versions
```

### Project Setup
```bash
setup_project node    # Setup Node.js project
setup_project python  # Setup Python project
setup_project ruby    # Setup Ruby project
setup_project go      # Setup Go project
```

### Version Management Examples
```bash
# Node.js (Volta)
volta pin node@20
volta pin pnpm@latest

# Python/Ruby/Go (mise)
mise use python@3.12
mise use ruby@3.3
mise use go@latest

# Python packages (uv - ultra fast)
uv pip install fastapi
uv pip list

# Project management (Rye)
rye init
rye add requests
rye sync
```

## 🚀 Setup Instructions for New Machine

### 1. Initial Setup
```bash
# Clone dotfiles
git clone [your-repo-url] ~/dotfiles
cd ~/dotfiles

# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Apple Silicon Mac
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Mac
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

### 2. Install Everything
```bash
# Install Homebrew packages
cd ~/dotfiles
./install.sh

# Install language tools
./setup-languages.sh

# Create symlinks
./link.sh

# Apply shell configuration
source ~/.zshrc
```

### 3. Configure Terminal
1. Open Terminal Preferences
2. Set font to "Hack Nerd Font"
3. Optionally install iTerm2 for better experience

### 4. Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 🔧 Troubleshooting

### Keyboard Issues
- If JIS keyboard mapping is wrong: Check Karabiner-Elements is running
- If Option+¥ doesn't produce backslash: Restart Karabiner-Elements

### Terminal Icons
- If icons show as boxes: Install and set Nerd Font in terminal
- Alternative: Use `lsn` command for no icons

### Language Tools
- If `mise` not found: Add `~/.local/bin` to PATH
- If Volta not found: Restart terminal after installation
- Python issues: Check both `python` and `python3` commands

### Performance
- Slow shell startup: Comment out unused language managers in .zshrc
- High memory usage: Disable unused Docker containers

## 📝 Maintenance

### Regular Updates
```bash
# Weekly
update_dev          # Update all tools
brew cleanup        # Clean old versions

# Monthly
brew doctor         # Check Homebrew health
mise doctor         # Check mise setup
```

### Backup
```bash
# Quick backup
backup_dotfiles     # Commits and pushes dotfiles

# Full backup
cd ~/dotfiles
brew bundle dump --force  # Update Brewfile with current packages
git add -A
git commit -m "Update: $(date)"
git push
```

## 🎯 Design Decisions

### Why These Tools?

1. **mise over asdf/nvm/rbenv**
   - Single tool for multiple languages
   - Faster performance (Rust-based)
   - Better project-specific version management

2. **Volta for Node.js**
   - Automatic version switching per project
   - Faster than nvm
   - Better npm/yarn/pnpm management

3. **uv for Python packages**
   - 10-100x faster than pip
   - Drop-in pip replacement
   - Rust-based for performance

4. **Karabiner-Elements for keyboard**
   - Most flexible keyboard remapping tool
   - GUI and JSON configuration
   - Active development and support

5. **eza over ls**
   - Modern replacement with better defaults
   - Git integration
   - Icons and colors
   - Tree view built-in

## 📚 Resources

- [mise documentation](https://mise.jdx.dev/)
- [Volta documentation](https://volta.sh/)
- [uv documentation](https://github.com/astral-sh/uv)
- [Rye documentation](https://rye-up.com/)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
- [Starship Prompt](https://starship.rs/)

## 🔄 Version History

- **2024-08-21**: Initial setup with modern tooling
  - Replaced traditional version managers with mise/Volta
  - Added uv for Python package management
  - Configured JIS keyboard support
  - Set up comprehensive shell environment

---

*This setup prioritizes modern, fast tools (mostly Rust-based) for better performance and developer experience.*