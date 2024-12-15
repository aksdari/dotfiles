# Overview

This is my dotfiles repository.

# Installation

1. Install prerequisites

```sh
brew install stow neovim lazygit npm go fzf font-meslo-lg-nerd-font
brew install powerlevel10k
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

2. Clone this repository

```sh
git clone https://github.com/aksdari/dotfiles.git
```

3. Use `stow` to symlink config files

```sh
stow -t ~ .
```

# Terminal Setup

## Wezterm

```sh
brew install --cask wezterm
```

## Configure powerlevel10k

```sh
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
# configure p10k
source ~/.zshrc
# you can use to trigger it manually:
p10k configure

```
