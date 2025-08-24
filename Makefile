.PHONY: all help healthcheck healthcheck-brew healthcheck-go healthcheck-volta healthcheck-mise healthcheck-git healthcheck-shell install install-brew install-go install-volta install-mise setup link clean update

# Default shell
SHELL := /bin/bash

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Enable color output
export TERM := xterm-256color

# Dotfiles directory
DOTFILES_DIR := $(shell pwd)
HOME_DIR := $(HOME)

# Default target
all: help

# Help command
help:
	@echo -e -e "$(BLUE)Dotfiles Management$(NC)"
	@echo -e ""
	@echo -e -e "$(GREEN)Available targets:$(NC)"
	@echo -e -e "  $(YELLOW)healthcheck$(NC)         - Check all tools and configurations"
	@echo -e -e "  $(YELLOW)healthcheck-brew$(NC)    - Check Homebrew installation and packages"
	@echo -e -e "  $(YELLOW)healthcheck-go$(NC)      - Check Go installation and environment"
	@echo -e -e "  $(YELLOW)healthcheck-ruby$(NC)    - Check Ruby installation and gems"
	@echo -e -e "  $(YELLOW)healthcheck-python$(NC)  - Check Python installation and pip/uv"
	@echo -e -e "  $(YELLOW)healthcheck-volta$(NC)   - Check Volta and Node.js setup"
	@echo -e -e "  $(YELLOW)healthcheck-mise$(NC)    - Check mise installation and plugins"
	@echo -e -e "  $(YELLOW)healthcheck-git$(NC)     - Check Git configuration"
	@echo -e -e "  $(YELLOW)healthcheck-shell$(NC)   - Check shell configuration"
	@echo -e ""
	@echo -e -e "  $(YELLOW)install$(NC)             - Install all tools and dependencies"
	@echo -e -e "  $(YELLOW)install-brew$(NC)        - Install Homebrew and packages"
	@echo -e -e "  $(YELLOW)install-go$(NC)          - Install Go via mise"
	@echo -e -e "  $(YELLOW)install-ruby$(NC)        - Install Ruby via mise"
	@echo -e -e "  $(YELLOW)install-python$(NC)      - Install Python via mise"
	@echo -e -e "  $(YELLOW)install-volta$(NC)       - Install Volta for Node.js management"
	@echo -e -e "  $(YELLOW)install-mise$(NC)        - Install mise for runtime management"
	@echo -e ""
	@echo -e -e "  $(YELLOW)setup$(NC)               - Initial setup for dotfiles"
	@echo -e -e "  $(YELLOW)link$(NC)                - Create symbolic links for dotfiles"
	@echo -e -e "  $(YELLOW)clean$(NC)               - Clean up broken symbolic links"
	@echo -e -e "  $(YELLOW)update$(NC)              - Update all tools and packages"
	@echo -e -e "  $(YELLOW)backup$(NC)              - Backup current dotfiles"

# Complete healthcheck
healthcheck: healthcheck-brew healthcheck-go healthcheck-ruby healthcheck-python healthcheck-volta healthcheck-mise healthcheck-git healthcheck-shell
	@echo -e ""
	@echo -e "$(GREEN)✓ All healthchecks completed$(NC)"

# Homebrew healthcheck
healthcheck-brew:
	@echo -e "$(BLUE)Checking Homebrew...$(NC)"
	@if command -v brew >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) Homebrew installed: $$(brew --version | head -1)"; \
		echo -e "$(GREEN)✓$(NC) Homebrew prefix: $$(brew --prefix)"; \
		outdated=$$(brew outdated 2>/dev/null | wc -l | xargs); \
		if [ "$$outdated" -gt 0 ]; then \
			echo -e "$(YELLOW)!$(NC) $$outdated packages outdated (run 'brew upgrade')"; \
		else \
			echo -e "$(GREEN)✓$(NC) All packages up to date"; \
		fi; \
		if [ -f "$(DOTFILES_DIR)/Brewfile" ]; then \
			echo -e "$(GREEN)✓$(NC) Brewfile found"; \
			missing=$$(brew bundle check --file="$(DOTFILES_DIR)/Brewfile" 2>&1 | grep "missing" | wc -l | xargs); \
			if [ "$$missing" -gt 0 ]; then \
				echo -e "$(YELLOW)!$(NC) $$missing formulae/casks missing from Brewfile"; \
			else \
				echo -e "$(GREEN)✓$(NC) All Brewfile dependencies installed"; \
			fi; \
		else \
			echo -e "$(YELLOW)!$(NC) Brewfile not found"; \
		fi; \
	else \
		echo -e "$(RED)✗$(NC) Homebrew not installed"; \
		echo "  Run: make install-brew"; \
	fi

# Go healthcheck
healthcheck-go:
	@echo -e "$(BLUE)Checking Go...$(NC)"
	@if command -v mise >/dev/null 2>&1 && mise list go 2>/dev/null | grep -q go; then \
		echo -e "$(GREEN)✓$(NC) Go managed by mise"; \
		if command -v go >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) Go version: $$(go version | cut -d' ' -f3)"; \
			echo -e "$(GREEN)✓$(NC) Go location: $$(which go)"; \
			if [ -n "$$GOPATH" ]; then \
				echo -e "$(GREEN)✓$(NC) GOPATH: $$GOPATH"; \
			else \
				echo -e "$(YELLOW)!$(NC) GOPATH not set (using default: $$HOME/go)"; \
			fi; \
		else \
			echo -e "$(YELLOW)!$(NC) Go binary not in PATH. Run: mise reshim"; \
		fi; \
	elif command -v go >/dev/null 2>&1; then \
		echo -e "$(YELLOW)!$(NC) Go installed but not managed by mise: $$(go version)"; \
		echo -e "  Consider using: make install-go"; \
	else \
		echo -e "$(RED)✗$(NC) Go not installed"; \
		echo -e "  Run: make install-go"; \
	fi

# Ruby healthcheck
healthcheck-ruby:
	@echo -e "$(BLUE)Checking Ruby...$(NC)"
	@if command -v mise >/dev/null 2>&1 && mise list ruby 2>/dev/null | grep -q ruby; then \
		echo -e "$(GREEN)✓$(NC) Ruby managed by mise"; \
		if command -v ruby >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) Ruby version: $$(ruby --version | cut -d' ' -f1-2)"; \
			echo -e "$(GREEN)✓$(NC) Ruby location: $$(which ruby)"; \
			if command -v gem >/dev/null 2>&1; then \
				echo -e "$(GREEN)✓$(NC) RubyGems: $$(gem --version)"; \
			fi; \
			if command -v bundler >/dev/null 2>&1; then \
				echo -e "$(GREEN)✓$(NC) Bundler: $$(bundler --version)"; \
			else \
				echo -e "$(YELLOW)!$(NC) Bundler not installed. Run: gem install bundler"; \
			fi; \
		else \
			echo -e "$(YELLOW)!$(NC) Ruby binary not in PATH. Run: mise reshim"; \
		fi; \
	elif command -v ruby >/dev/null 2>&1; then \
		echo -e "$(YELLOW)!$(NC) Ruby installed but not managed by mise: $$(ruby --version)"; \
		echo -e "  Consider using: make install-ruby"; \
	else \
		echo -e "$(RED)✗$(NC) Ruby not installed"; \
		echo -e "  Run: make install-ruby"; \
	fi

# Python healthcheck
healthcheck-python:
	@echo -e "$(BLUE)Checking Python...$(NC)"
	@if command -v mise >/dev/null 2>&1 && mise list python 2>/dev/null | grep -q python; then \
		echo -e "$(GREEN)✓$(NC) Python managed by mise"; \
		if command -v python >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) Python version: $$(python --version)"; \
			echo -e "$(GREEN)✓$(NC) Python location: $$(which python)"; \
			if command -v pip >/dev/null 2>&1; then \
				echo -e "$(GREEN)✓$(NC) pip: $$(pip --version | cut -d' ' -f2)"; \
			fi; \
			if command -v uv >/dev/null 2>&1; then \
				echo -e "$(GREEN)✓$(NC) uv (fast pip): $$(uv --version)"; \
			else \
				echo -e "$(YELLOW)!$(NC) uv not installed. Run: brew install uv"; \
			fi; \
		else \
			echo -e "$(YELLOW)!$(NC) Python binary not in PATH. Run: mise reshim"; \
		fi; \
	elif command -v python3 >/dev/null 2>&1; then \
		echo -e "$(YELLOW)!$(NC) Python installed but not managed by mise: $$(python3 --version)"; \
		echo -e "  Consider using: make install-python"; \
	else \
		echo -e "$(RED)✗$(NC) Python not installed"; \
		echo -e "  Run: make install-python"; \
	fi

# Volta healthcheck
healthcheck-volta:
	@echo -e "$(BLUE)Checking Volta...$(NC)"
	@if command -v volta >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) Volta installed: $$(volta --version)"; \
		if command -v node >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) Node.js: $$(node --version)"; \
		else \
			echo -e "$(YELLOW)!$(NC) Node.js not installed via Volta"; \
		fi; \
		if command -v npm >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) npm: $$(npm --version)"; \
		else \
			echo -e "$(YELLOW)!$(NC) npm not found"; \
		fi; \
		if command -v yarn >/dev/null 2>&1; then \
			echo -e "$(GREEN)✓$(NC) Yarn: $$(yarn --version)"; \
		else \
			echo -e "$(YELLOW)!$(NC) Yarn not installed"; \
		fi; \
	else \
		echo -e "$(RED)✗$(NC) Volta not installed"; \
		echo "  Run: make install-volta"; \
	fi

# mise healthcheck
healthcheck-mise:
	@echo -e "$(BLUE)Checking mise...$(NC)"
	@if command -v mise >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) mise installed: $$(mise --version)"; \
		echo -e "$(GREEN)✓$(NC) mise plugins:"; \
		mise plugin list 2>/dev/null | sed 's/^/    /'; \
		if [ -f "$(HOME)/.tool-versions" ] || [ -f ".tool-versions" ]; then \
			echo -e "$(GREEN)✓$(NC) .tool-versions file found"; \
		else \
			echo -e "$(YELLOW)!$(NC) No .tool-versions file found"; \
		fi; \
	else \
		echo -e "$(RED)✗$(NC) mise not installed"; \
		echo "  Run: make install-mise"; \
	fi

# Git healthcheck
healthcheck-git:
	@echo -e "$(BLUE)Checking Git...$(NC)"
	@if command -v git >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) Git installed: $$(git --version)"; \
		if [ -n "$$(git config --global user.name)" ]; then \
			echo -e "$(GREEN)✓$(NC) Git user: $$(git config --global user.name)"; \
		else \
			echo -e "$(YELLOW)!$(NC) Git user.name not configured"; \
		fi; \
		if [ -n "$$(git config --global user.email)" ]; then \
			echo -e "$(GREEN)✓$(NC) Git email: $$(git config --global user.email)"; \
		else \
			echo -e "$(YELLOW)!$(NC) Git user.email not configured"; \
		fi; \
		if [ -f "$(HOME)/.gitconfig" ]; then \
			echo -e "$(GREEN)✓$(NC) .gitconfig exists"; \
		else \
			echo -e "$(YELLOW)!$(NC) .gitconfig not found"; \
		fi; \
		if [ -f "$(HOME)/.gitignore_global" ]; then \
			echo -e "$(GREEN)✓$(NC) Global gitignore configured"; \
		else \
			echo -e "$(YELLOW)!$(NC) Global gitignore not found"; \
		fi; \
	else \
		echo -e "$(RED)✗$(NC) Git not installed"; \
	fi

# Shell healthcheck
healthcheck-shell:
	@echo -e "$(BLUE)Checking Shell Configuration...$(NC)"
	@echo -e "$(GREEN)✓$(NC) Current shell: $$SHELL"
	@echo -e "$(GREEN)✓$(NC) Shell version: $$BASH_VERSION"
	@if [ -f "$(HOME)/.zshrc" ]; then \
		echo -e "$(GREEN)✓$(NC) .zshrc exists"; \
	else \
		echo -e "$(YELLOW)!$(NC) .zshrc not found"; \
	fi
	@if [ -f "$(HOME)/.bash_profile" ]; then \
		echo -e "$(GREEN)✓$(NC) .bash_profile exists"; \
	else \
		echo -e "$(YELLOW)!$(NC) .bash_profile not found"; \
	fi
	@if [ -f "$(HOME)/.bashrc" ]; then \
		echo -e "$(GREEN)✓$(NC) .bashrc exists"; \
	else \
		echo -e "$(YELLOW)!$(NC) .bashrc not found"; \
	fi
	@if command -v starship >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) Starship prompt: $$(starship --version)"; \
	else \
		echo -e "$(YELLOW)!$(NC) Starship not installed"; \
	fi

# Install everything
install: install-brew install-mise install-go install-ruby install-python install-volta
	@echo -e "$(GREEN)✓ All tools installed$(NC)"

# Install Homebrew
install-brew:
	@echo -e "$(BLUE)Installing Homebrew...$(NC)"
	@if ! command -v brew >/dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo -e "$(GREEN)✓$(NC) Homebrew already installed"; \
	fi
	@if [ -f "$(DOTFILES_DIR)/Brewfile" ]; then \
		echo -e "$(BLUE)Installing Brewfile packages...$(NC)"; \
		brew bundle --file="$(DOTFILES_DIR)/Brewfile"; \
	fi

# Install Go via mise
install-go:
	@echo -e "$(BLUE)Installing Go via mise...$(NC)"
	@if command -v mise >/dev/null 2>&1; then \
		mise install go@latest; \
		mise use --global go@latest; \
		echo -e "$(GREEN)✓$(NC) Go installed via mise"; \
	else \
		echo -e "$(RED)✗$(NC) Please install mise first (make install-mise)"; \
	fi

# Install Ruby via mise
install-ruby:
	@echo -e "$(BLUE)Installing Ruby via mise...$(NC)"
	@if command -v mise >/dev/null 2>&1; then \
		mise install ruby@latest; \
		mise use --global ruby@latest; \
		echo -e "$(GREEN)✓$(NC) Ruby installed via mise"; \
		echo -e "$(BLUE)Installing bundler...$(NC)"; \
		gem install bundler; \
	else \
		echo -e "$(RED)✗$(NC) Please install mise first (make install-mise)"; \
	fi

# Install Python via mise
install-python:
	@echo -e "$(BLUE)Installing Python via mise...$(NC)"
	@if command -v mise >/dev/null 2>&1; then \
		mise install python@3.12; \
		mise install python@3.11; \
		mise use --global python@3.12; \
		echo -e "$(GREEN)✓$(NC) Python installed via mise"; \
		if ! command -v uv >/dev/null 2>&1; then \
			echo -e "$(BLUE)Installing uv (fast pip replacement)...$(NC)"; \
			brew install uv; \
		fi; \
	else \
		echo -e "$(RED)✗$(NC) Please install mise first (make install-mise)"; \
	fi

# Install Volta
install-volta:
	@echo -e "$(BLUE)Installing Volta...$(NC)"
	@if ! command -v volta >/dev/null 2>&1; then \
		curl https://get.volta.sh | bash; \
		export PATH="$$HOME/.volta/bin:$$PATH"; \
		volta install node@lts; \
	else \
		echo -e "$(GREEN)✓$(NC) Volta already installed"; \
	fi

# Install mise
install-mise:
	@echo -e "$(BLUE)Installing mise...$(NC)"
	@if ! command -v mise >/dev/null 2>&1; then \
		curl https://mise.run | sh; \
		echo 'eval "$$(~/.local/bin/mise activate bash)"' >> ~/.bashrc; \
		echo 'eval "$$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc; \
	else \
		echo -e "$(GREEN)✓$(NC) mise already installed"; \
	fi

# Initial setup
setup:
	@echo -e "$(BLUE)Setting up dotfiles...$(NC)"
	@if [ ! -d "$(DOTFILES_DIR)/.git" ]; then \
		git init; \
	fi
	@$(MAKE) link
	@$(MAKE) install
	@echo -e "$(GREEN)✓ Setup complete$(NC)"

# Create symbolic links
link:
	@echo -e "$(BLUE)Creating symbolic links...$(NC)"
	@if [ -f "$(DOTFILES_DIR)/link.sh" ]; then \
		bash "$(DOTFILES_DIR)/link.sh"; \
	else \
		echo -e "$(YELLOW)Creating links manually...$(NC)"; \
		for file in $(DOTFILES_DIR)/.* $(DOTFILES_DIR)/*; do \
			name=$$(basename "$$file"); \
			if [ "$$name" != "." ] && [ "$$name" != ".." ] && [ "$$name" != ".git" ] && [ "$$name" != "Makefile" ]; then \
				if [ -e "$$file" ]; then \
					ln -sfn "$$file" "$(HOME_DIR)/$$name" && echo -e "$(GREEN)✓$(NC) Linked $$name"; \
				fi; \
			fi; \
		done; \
	fi

# Clean broken symbolic links
clean:
	@echo -e "$(BLUE)Cleaning broken symbolic links...$(NC)"
	@find $(HOME_DIR) -maxdepth 1 -type l ! -exec test -e {} \; -print -delete | while read link; do \
		echo -e "$(YELLOW)✗$(NC) Removed broken link: $$link"; \
	done
	@echo -e "$(GREEN)✓ Cleanup complete$(NC)"

# Update all tools
update:
	@echo -e "$(BLUE)Updating all tools...$(NC)"
	@if command -v brew >/dev/null 2>&1; then \
		echo -e "$(BLUE)Updating Homebrew...$(NC)"; \
		brew update && brew upgrade && brew cleanup; \
	fi
	@if command -v mise >/dev/null 2>&1; then \
		echo -e "$(BLUE)Updating mise...$(NC)"; \
		mise self-update; \
		mise plugin update --all; \
	fi
	@if command -v volta >/dev/null 2>&1; then \
		echo -e "$(BLUE)Updating Volta tools...$(NC)"; \
		volta install node@lts; \
	fi
	@echo -e "$(GREEN)✓ All tools updated$(NC)"

# Backup dotfiles
backup:
	@echo -e "$(BLUE)Backing up dotfiles...$(NC)"
	@backup_dir="$(HOME_DIR)/dotfiles_backup_$$(date +%Y%m%d_%H%M%S)"; \
	mkdir -p "$$backup_dir"; \
	for file in .zshrc .bashrc .bash_profile .gitconfig .vimrc .tmux.conf; do \
		if [ -f "$(HOME_DIR)/$$file" ]; then \
			cp "$(HOME_DIR)/$$file" "$$backup_dir/" && echo -e "$(GREEN)✓$(NC) Backed up $$file"; \
		fi; \
	done; \
	echo -e "$(GREEN)✓ Backup saved to $$backup_dir$(NC)"

# Verify dotfiles installation
verify:
	@printf "$(BLUE)Verifying dotfiles installation...$(NC)\n"
	@errors=0; \
	for file in .zshrc .bashrc .gitconfig; do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			target=$$(readlink "$(HOME_DIR)/$$file"); \
			if [ -e "$$target" ]; then \
				printf "$(GREEN)✓$(NC) $$file correctly linked\n"; \
			else \
				printf "$(RED)✗$(NC) $$file link broken\n"; \
				errors=$$((errors + 1)); \
			fi; \
		else \
			printf "$(YELLOW)!$(NC) $$file not linked\n"; \
		fi; \
	done; \
	if [ $$errors -eq 0 ]; then \
		printf "$(GREEN)✓ All verifications passed$(NC)\n"; \
	else \
		printf "$(RED)✗ $$errors errors found$(NC)\n"; \
		exit 1; \
	fi

# Development environment check
dev-check:
	@echo -e "$(BLUE)Checking development environment...$(NC)"
	@$(MAKE) healthcheck-git
	@echo -e ""
	@$(MAKE) healthcheck-go
	@echo -e ""
	@$(MAKE) healthcheck-volta
	@echo -e ""
	@if command -v docker >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) Docker: $$(docker --version)"; \
	else \
		echo -e "$(YELLOW)!$(NC) Docker not installed"; \
	fi
	@if command -v code >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓$(NC) VS Code installed"; \
	else \
		echo -e "$(YELLOW)!$(NC) VS Code not installed"; \
	fi