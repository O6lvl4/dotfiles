#!/bin/bash

set -e

echo "🚀 Modern Development Languages Setup (2024)"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ================================
# mise (Multi-language Version Manager)
# ================================
echo -e "${BLUE}🔧 Installing mise (formerly rtx) - Universal version manager${NC}"
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    
    # Initialize mise
    eval "$(mise activate bash)"
    
    echo -e "${GREEN}✅ mise installed${NC}"
else
    echo -e "${GREEN}✅ mise already installed${NC}"
fi

# ================================
# Node.js - Volta (Fast, Rust-based)
# ================================
echo -e "${YELLOW}📦 Setting up Node.js with Volta...${NC}"
if ! command -v volta &> /dev/null; then
    echo "Installing Volta..."
    curl https://get.volta.sh | bash
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
    
    echo "Installing Node.js LTS..."
    volta install node@lts
    
    echo "Installing essential npm packages..."
    volta install pnpm yarn npm-check-updates
    
    echo -e "${GREEN}✅ Volta + Node.js installed${NC}"
else
    echo -e "${GREEN}✅ Volta already installed${NC}"
fi

# ================================
# Python - uv (Ultra-fast Python package manager)
# ================================
echo -e "${YELLOW}📦 Setting up Python with uv...${NC}"
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
    
    echo "Installing Python with mise..."
    mise use --global python@3.12
    mise use --global python@3.11
    
    echo -e "${GREEN}✅ uv + Python installed${NC}"
else
    echo -e "${GREEN}✅ uv already installed${NC}"
fi

# ================================
# Rye (Modern Python project manager)
# ================================
echo -e "${YELLOW}📦 Setting up Rye for Python project management...${NC}"
if ! command -v rye &> /dev/null; then
    echo "Installing Rye..."
    curl -sSf https://rye.astral.sh/get | bash
    source "$HOME/.rye/env"
    
    echo -e "${GREEN}✅ Rye installed${NC}"
else
    echo -e "${GREEN}✅ Rye already installed${NC}"
fi

# ================================
# Ruby - Using mise
# ================================
echo -e "${YELLOW}📦 Setting up Ruby with mise...${NC}"
if ! mise list ruby &> /dev/null; then
    echo "Installing Ruby with mise..."
    mise use --global ruby@3.3
    
    echo "Installing essential Ruby gems..."
    gem install bundler rails
    
    echo -e "${GREEN}✅ Ruby installed via mise${NC}"
else
    echo -e "${GREEN}✅ Ruby already installed${NC}"
fi

# ================================
# Java - SDKMAN (Still the best)
# ================================
echo -e "${YELLOW}📦 Setting up Java with SDKMAN...${NC}"
if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
    echo "Installing Java 21 LTS (latest LTS)..."
    sdk install java 21.0.2-tem
    sdk default java 21.0.2-tem
    
    echo "Installing Java 17 LTS (previous LTS)..."
    sdk install java 17.0.10-tem
    
    echo "Installing build tools..."
    sdk install maven
    sdk install gradle
    
    echo -e "${GREEN}✅ SDKMAN + Java installed${NC}"
else
    echo -e "${GREEN}✅ SDKMAN already installed${NC}"
fi

# ================================
# Go - Using mise
# ================================
echo -e "${YELLOW}📦 Setting up Go with mise...${NC}"
if ! mise list go &> /dev/null; then
    echo "Installing Go with mise..."
    mise use --global go@latest
    
    echo "Installing common Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    echo -e "${GREEN}✅ Go installed via mise${NC}"
else
    echo -e "${GREEN}✅ Go already installed${NC}"
fi

# ================================
# Rust - Rustup (Official, still the best)
# ================================
echo -e "${YELLOW}📦 Setting up Rust...${NC}"
if [ ! -d "$HOME/.cargo" ]; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    echo "Installing common Rust tools..."
    cargo install cargo-edit cargo-watch cargo-make sccache
    
    echo -e "${GREEN}✅ Rust installed${NC}"
else
    echo -e "${GREEN}✅ Rust already installed${NC}"
fi

# ================================
# Bun (JavaScript runtime, faster than Node)
# ================================
echo -e "${YELLOW}📦 Setting up Bun...${NC}"
if ! command -v bun &> /dev/null; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    
    echo -e "${GREEN}✅ Bun installed${NC}"
else
    echo -e "${GREEN}✅ Bun already installed${NC}"
fi

# ================================
# Proto (Another modern toolchain manager)
# ================================
echo -e "${YELLOW}📦 Setting up Proto (optional toolchain manager)...${NC}"
if ! command -v proto &> /dev/null; then
    echo "Installing Proto..."
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash
    export PROTO_HOME="$HOME/.proto"
    export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
    
    echo -e "${GREEN}✅ Proto installed${NC}"
else
    echo -e "${GREEN}✅ Proto already installed${NC}"
fi

# ================================
# Setup mise configuration
# ================================
echo -e "${BLUE}📝 Creating global mise configuration...${NC}"
cat > "$HOME/.config/mise/config.toml" << 'EOF'
[settings]
experimental = true
legacy_version_file = true

[tools]
node = "lts"
python = ["3.12", "3.11"]
ruby = "3.3"
go = "latest"

[alias.node]
lts = "20"
EOF

# ================================
# Verification
# ================================
echo ""
echo "================================"
echo "📋 Installation Summary"
echo "================================"
echo ""

# Check Volta/Node
if command -v volta &> /dev/null; then
    echo -e "${GREEN}✅ Volta: $(volta --version)${NC}"
    echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
else
    echo -e "${RED}❌ Volta/Node not found${NC}"
fi

# Check Python/uv
if command -v uv &> /dev/null; then
    echo -e "${GREEN}✅ uv: $(uv --version)${NC}"
fi
if command -v rye &> /dev/null; then
    echo -e "${GREEN}✅ Rye: $(rye --version)${NC}"
fi
if command -v python &> /dev/null; then
    echo -e "${GREEN}✅ Python: $(python --version 2>&1)${NC}"
fi

# Check Ruby
if command -v ruby &> /dev/null; then
    echo -e "${GREEN}✅ Ruby: $(ruby --version | head -n1)${NC}"
fi

# Check Java
if command -v java &> /dev/null; then
    echo -e "${GREEN}✅ Java: $(java --version 2>&1 | head -n1)${NC}"
fi

# Check Go
if command -v go &> /dev/null; then
    echo -e "${GREEN}✅ Go: $(go version)${NC}"
fi

# Check Rust
if command -v rustc &> /dev/null; then
    echo -e "${GREEN}✅ Rust: $(rustc --version)${NC}"
fi

# Check Bun
if command -v bun &> /dev/null; then
    echo -e "${GREEN}✅ Bun: $(bun --version)${NC}"
fi

# Check mise
if command -v mise &> /dev/null; then
    echo -e "${GREEN}✅ mise: $(mise --version)${NC}"
fi

echo ""
echo "================================"
echo "✨ Modern Setup Complete!"
echo "================================"
echo ""
echo "⚠️  IMPORTANT: Reload your shell configuration:"
echo "   source ~/.zshrc"
echo ""
echo "📝 Quick Reference:"
echo ""
echo "  🔧 mise (Multiple languages):"
echo "     mise list              # List installed versions"
echo "     mise use node@20       # Use Node 20 in current project"
echo "     mise global ruby@3.3   # Set global Ruby version"
echo ""
echo "  ⚡ Volta (Node.js):"
echo "     volta install node@18  # Install Node 18"
echo "     volta pin node@18      # Pin Node version in project"
echo ""
echo "  🐍 Python:"
echo "     uv pip install ...     # Ultra-fast pip replacement"
echo "     rye init              # Initialize new Python project"
echo "     rye sync              # Sync project dependencies"
echo ""
echo "  ☕ Java (SDKMAN):"
echo "     sdk list java         # List available Java versions"
echo "     sdk use java 21.0.2-tem"
echo ""
echo "  🦀 Rust:"
echo "     rustup update         # Update Rust"
echo "     cargo new project     # Create new project"
echo ""
echo "  🍞 Bun:"
echo "     bun run script.js     # Run JavaScript (faster than Node)"
echo "     bun install          # Install packages (faster than npm)"