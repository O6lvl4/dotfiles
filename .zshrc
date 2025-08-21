# ================================
# Modern Zsh Configuration (2024)
# ================================

# Path to your dotfiles
export DOTFILES="$HOME/dotfiles"

# ================================
# Homebrew
# ================================
# Check if running on Apple Silicon or Intel
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ================================
# mise (Universal Version Manager)
# ================================
if [[ -f "$HOME/.local/bin/mise" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate zsh)"
fi

# ================================
# Volta (Node.js Version Manager)
# ================================
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# ================================
# uv (Fast Python Package Manager)
# ================================
# uv is installed via cargo, path handled below

# ================================
# Rye (Python Project Manager)
# ================================
source "$HOME/.rye/env" 2>/dev/null || true

# ================================
# Java - SDKMAN
# ================================
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# ================================
# Rust
# ================================
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ================================
# Bun
# ================================
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ================================
# Proto (Optional Toolchain Manager)
# ================================
export PROTO_HOME="$HOME/.proto"
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"

# ================================
# Go
# ================================
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# ================================
# Aliases
# ================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# List directory contents
if command -v eza &> /dev/null; then
    # アイコン付き版をデフォルトに
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alh --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias l='eza -F --icons --group-directories-first'
    alias tree='eza --tree --icons'
    
    # アイコンなし版（必要な場合）
    alias lsn='eza --group-directories-first'
    alias lln='eza -alh --group-directories-first'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Git
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gs='git status'
alias gd='git diff'
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias gp='git push'
alias gu='git unstage'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --decorate --graph'
alias gst='git stash'
alias gpop='git stash pop'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'

# Development
alias v='nvim'
alias vim='nvim'
alias code.='code .'

# Version Management
alias m='mise'
alias ml='mise list'
alias mu='mise use'
alias mg='mise global'

# Python
alias py='python'
alias pip='uv pip'
alias venv='python -m venv'
alias activate='source venv/bin/activate'

# Node
alias n='node'
alias p='pnpm'
alias y='yarn'
alias b='bun'

# System
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR ~/.zshrc'
alias dotfiles='cd $DOTFILES'

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"

# ================================
# Functions
# ================================

# Create a new directory and enter it
mkd() {
    mkdir -p "$@" && cd "$_"
}

# Change to a project directory
proj() {
    cd ~/Projects/"$1"
}

# Quick project setup with mise
setup_project() {
    local lang=$1
    if [[ -z "$lang" ]]; then
        echo "Usage: setup_project <language>"
        echo "Available: node, python, ruby, go"
        return 1
    fi
    
    case $lang in
        node)
            volta pin node@lts
            volta pin pnpm@latest
            pnpm init
            ;;
        python)
            rye init
            rye sync
            ;;
        ruby)
            mise use ruby@latest
            bundle init
            ;;
        go)
            mise use go@latest
            go mod init
            ;;
        *)
            echo "Unknown language: $lang"
            ;;
    esac
}

# Update all development tools
update_dev() {
    echo "🔄 Updating development tools..."
    
    # Update Homebrew
    echo "📦 Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
    
    # Update mise tools
    echo "🔧 Updating mise tools..."
    mise upgrade
    
    # Update Rust
    echo "🦀 Updating Rust..."
    rustup update
    
    # Update Volta tools
    echo "⚡ Updating Node tools..."
    volta install node@lts
    
    # Update Python tools
    echo "🐍 Updating Python tools..."
    uv pip install --upgrade pip setuptools wheel
    
    echo "✅ All updates complete!"
}

# Quick backup of dotfiles
backup_dotfiles() {
    cd $DOTFILES
    git add -A
    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
    git push
}

# Show versions of all managed languages
versions() {
    echo "📋 Language Versions:"
    echo "━━━━━━━━━━━━━━━━━━━━"
    
    if command -v node &> /dev/null; then
        echo "Node.js: $(node --version)"
    fi
    
    if command -v python &> /dev/null; then
        echo "Python:  $(python --version 2>&1 | cut -d' ' -f2)"
    fi
    
    if command -v ruby &> /dev/null; then
        echo "Ruby:    $(ruby --version | cut -d' ' -f2)"
    fi
    
    if command -v go &> /dev/null; then
        echo "Go:      $(go version | cut -d' ' -f3 | sed 's/go//')"
    fi
    
    if command -v rustc &> /dev/null; then
        echo "Rust:    $(rustc --version | cut -d' ' -f2)"
    fi
    
    if command -v java &> /dev/null; then
        echo "Java:    $(java --version 2>&1 | head -n1 | cut -d' ' -f2)"
    fi
    
    if command -v bun &> /dev/null; then
        echo "Bun:     $(bun --version)"
    fi
}

# ================================
# Prompt - Starship
# ================================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ================================
# FZF - Fuzzy Finder
# ================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ================================
# Zsh Options
# ================================
setopt AUTO_CD                # Change directory by typing directory name
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive mode
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE      # Ignore commands that start with space
setopt SHARE_HISTORY          # Share history between sessions
setopt EXTENDED_HISTORY       # Add timestamps to history

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# ================================
# Completion
# ================================
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive completion

# ================================
# Key Bindings
# ================================
bindkey -e  # Use emacs key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ================================
# Local Configuration
# ================================
# Source local configuration if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local