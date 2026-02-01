#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

PKGS=(
  neovim
)

for pkg in "${PKGS[@]}"; do
  echo "Stowing $pkg"
  stow --target="$HOME" "$pkg"
done
