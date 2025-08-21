# AI Assistant Context for dotfiles

This file helps AI assistants understand the current development environment setup.

## Quick Facts
- **OS**: macOS Ventura (Intel Mac)
- **Shell**: Zsh with custom configuration
- **Package Manager**: Homebrew + modern language version managers
- **Keyboard**: JIS layout with Karabiner-Elements remapping

## Current Setup Status

### ✅ Completed
- Homebrew installed and configured
- Karabiner-Elements configured for JIS keyboard
- Modern language version managers installed:
  - mise (universal version manager)
  - Volta (Node.js)
  - uv (Python packages)
  - SDKMAN (Java)
- Shell configuration with aliases and functions
- Git configuration
- Nerd Fonts installed for terminal icons

### 🔄 Partially Complete
- Rye (Python project manager) - needs terminal for interactive install
- Some Homebrew casks may need manual installation

### Language Versions Installed
- Python: 3.12.11, 3.11.13 (via mise)
- Node.js: LTS (via Volta)
- Others: Ready to install on demand

## Key Files

| File | Purpose |
|------|---------|
| `.zshrc` | Shell configuration with all paths and aliases |
| `Brewfile` | Homebrew packages (languages excluded, managed separately) |
| `setup-languages.sh` | Installs modern language version managers |
| `karabiner/karabiner.json` | JIS keyboard mapping configuration |
| `SETUP_GUIDE.md` | Comprehensive documentation |

## Common Tasks for AI Assistants

### Adding a new tool
1. Check if it should be in Brewfile or managed by language tools
2. Update appropriate configuration file
3. Document in SETUP_GUIDE.md if significant

### Debugging issues
1. Check if paths are correctly set in .zshrc
2. Verify tools are installed (`which [tool]`)
3. Check if shell was reloaded (`source ~/.zshrc`)

### Language-specific tasks
- **Node.js**: Use Volta (`volta pin node@version`)
- **Python**: Use mise for versions, uv for packages
- **Ruby/Go**: Use mise (`mise use ruby@version`)
- **Java**: Use SDKMAN (`sdk use java version`)

## Important Commands

```bash
# Update everything
update_dev

# Check all versions
versions

# Quick project setup
setup_project [node|python|ruby|go]

# Backup dotfiles
backup_dotfiles
```

## Known Issues & Solutions

1. **Terminal icons showing as boxes**
   - Solution: Set terminal font to "Hack Nerd Font"

2. **Keyboard producing wrong characters**
   - Solution: Ensure Karabiner-Elements is running
   - Check: System Preferences → Keyboard → Input Sources → Japanese

3. **Command not found after installation**
   - Solution: `source ~/.zshrc` or open new terminal

## Environment Philosophy

This setup prioritizes:
1. **Speed**: Rust-based tools where possible (mise, Volta, uv, eza)
2. **Flexibility**: Project-specific versions without conflicts
3. **Simplicity**: Unified tools managing multiple languages
4. **Modernity**: Latest best practices for 2024

## For Future AI Assistants

When helping with this environment:
1. Prefer mise for new language installations
2. Use uv instead of pip for Python packages
3. Keep Brewfile for apps, not languages
4. Document significant changes in SETUP_GUIDE.md
5. Test commands before suggesting them
6. Consider both Intel and Apple Silicon Mac compatibility