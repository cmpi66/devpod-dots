#!/usr/bin/env bash
set -euo pipefail

# Remove default zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  rm -f "$HOME/.zshrc"
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
