# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environments using GNU Stow for symlink management. The repository structure mirrors the home directory layout.

## Core Commands

### Initial Setup
```sh
# Install prerequisites
brew install stow neovim lazygit npm go fzf font-meslo-lg-nerd-font powerlevel10k
brew install --cask wezterm
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Clone and apply dotfiles
git clone https://github.com/aksdari/dotfiles.git
cd dotfiles
stow -t ~ .

# Configure shell theme
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
source ~/.zshrc
p10k configure
```

### Stow Management
```sh
stow -t ~ .        # Apply symlinks to home directory
stow -D .          # Remove symlinks
stow -n -t ~ .     # Dry run to preview changes
```

### Neovim Development
```sh
nvim               # Launch Neovim (vim is aliased)
:Lazy sync         # Update Neovim plugins
:Mason             # Manage LSP servers and tools
:checkhealth       # Verify configuration
```

## Architecture

### Configuration Management
- **Stow**: Manages symlinks from repository to home directory
- **Structure**: Repository layout mirrors `~/.config/` and home directory structure
- **Exclusions**: `.stow-local-ignore` prevents `.git`, `scripts/`, `README.md`, and `setup.sh` from being stowed

### Neovim Configuration (`/.config/nvim/`)
- **Framework**: LazyVim with extensive language support (Go, Python, Rust, SQL, Terraform)
- **Plugin Management**: Uses lazy.nvim with configurations in `lua/plugins/`
- **Key Features**:
  - AI integration via GitHub Copilot (`lua/plugins/ai.lua`)
  - Testing with neotest framework
  - Git integration with gitsigns
  - FZF and flash navigation
  - Tmux navigation support
  - Multi-cursor editing

### Terminal Stack
- **Shell**: Zsh + Oh-My-Zsh + Powerlevel10k
- **Terminal**: Wezterm (primary) with Catppuccin Mocha theme
- **Multiplexer**: Tmux with Ctrl-A prefix and mouse support
- **Window Manager**: AeroSpace for tiling with auto-orientation
- **Font**: MesloLGS Nerd Font Mono (size 13)

### Language Support and Tools
- **Go**: Full LSP, debugging, and test support via gopls
- **Python**: pyright LSP with neotest integration
- **Rust**: rust-analyzer with cargo integration
- **Web**: ESLint, Prettier, TypeScript support
- **Database**: SQL formatting and completion
- **Infrastructure**: Terraform LSP and formatting

### Formatting and Linting
- **Lua**: stylua (2 spaces, 120 column width)
- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: Configured through pyright
- **Go**: gofmt/goimports via gopls
- **General**: Format on save enabled in Neovim

## Key File Locations

When modifying configurations, edit these files directly in the repository:
- `.zshrc` - Shell configuration and aliases
- `.wezterm.lua` - Terminal emulator settings
- `.tmux.conf` - Tmux configuration
- `.aerospace.toml` - Window manager settings
- `.config/nvim/init.lua` - Neovim entry point
- `.config/nvim/lua/plugins/` - Individual plugin configurations
- `.config/alacritty/alacritty.toml` - Alternative terminal configuration

After editing, run `stow -t ~ .` from the repository root to apply changes system-wide.