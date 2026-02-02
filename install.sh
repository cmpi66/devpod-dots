#!/usr/bin/env bash
set -euo pipefail

# Remove default zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  rm -f "$HOME/.zshrc"
fi

# install zap
if [ ! -d "$HOME/.local/share/zap" ]; then
  zsh <(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) \
    --branch release-v1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

PKGS=(
  neovim
  shell
  starship
  zsh
)

for pkg in "${PKGS[@]}"; do
  echo "Stowing $pkg"
  stow --target="$HOME" "$pkg"
done
