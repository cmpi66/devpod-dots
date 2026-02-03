#!/usr/bin/env bash
set -euo pipefail

# Remove default zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  rm -f "$HOME/.zshrc"
fi

# # Ensure zsh config dir exists
# mkdir -p "$HOME/.config/zsh"

# # install zap
# if [ ! -d "$HOME/.local/share/zap" ]; then
#   zsh <(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) \
#     --branch release-v1
# fi
#
# # Remove again
# if [ -d "$HOME/.config/zsh" ]; then
#   rm -rf "$HOME/.config/zsh"
# fi

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

# install zap
if [ ! -d "$HOME/.local/share/zap" ]; then
  zsh <(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) \
    --branch release-v1
fi
