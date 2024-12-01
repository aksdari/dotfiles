#!/bin/bash

BrewInstall() {
  brew install neovim lazygit npm go fzf
}

OtherInstalls() {
  # install shfmt
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
}

CreateSymlinks() {
  # neovim config
  ln -sf ~/github/dotfiles/nvim ~/.config/nvim

  # tmux config
  ln -sf ~/github/dotfiles/.tmux.conf ~/.tmux.conf

  # zshrc file
  mv ~/.zshrc ~/.zshrc.bak
  rm -rf ~/.zshrc
  ln -sf ~/github/dotfiles/.zshrc ~/.zshrc
}

BrewInstall
CreateSymlinks
echo "Dotfiles setup complete!"
