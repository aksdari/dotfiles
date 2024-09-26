#!/bin/bash

BrewInstall() {
  brew install neovim lazygit npm go
}

OtherInstalls() {
  # install shfmt
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
}

CreateSymlinks() {
  ln -sf ~/github/dotfiles/nvim ~/.config/nvim
  rm -rf ~/.zshrc
  ln -sf ~/github/dotfiles/.zshrc ~/.zshrc
}

BrewInstall
CreateSymlink
echo "Dotfiles setup complete!"
