#!/usr/bin/env bash
# ~/dotfiles/setup.sh
#
# Bootstrap script for AJ's dev environment (WSL/Ubuntu side).
#
# Prerequisites (do these manually first, they can't be scripted from inside WSL):
#   1. On Windows (PowerShell as Admin): wsl --install   -> restart -> finish Ubuntu setup
#   2. Generate an SSH key and add it to GitHub, then:
#        git clone git@github.com:Aiaj-stacks/dotfiles.git ~/dotfiles
#   3. Install WezTerm + a Nerd Font on the WINDOWS side (this script only handles WSL/Linux tools)
#
# Usage:
#   cd ~/dotfiles
#   chmod +x setup.sh
#   ./setup.sh

set -e  # stop on first error

echo "=============================================="
echo " AJ's Dev Environment Bootstrap"
echo "=============================================="

DOTFILES="$HOME/dotfiles"

# --------------------------------------------------
# 1. System packages needed for building things later
# --------------------------------------------------
echo ""
echo "--> Installing base build tools (make, unzip, gcc)..."
sudo apt update
sudo apt install -y make unzip gcc curl git

# --------------------------------------------------
# 2. Nix (single-user install)
# --------------------------------------------------
if ! command -v nix &> /dev/null; then
  echo ""
  echo "--> Installing Nix..."
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --no-daemon
  # shellcheck disable=SC1090
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"

  if ! grep -q "nix.sh" "$HOME/.bashrc" 2>/dev/null; then
    echo ". $HOME/.nix-profile/etc/profile.d/nix.sh" >> "$HOME/.bashrc"
  fi
else
  echo ""
  echo "--> Nix already installed, skipping."
fi

# --------------------------------------------------
# 3. Restore nix.conf (enables flakes, needed for herdr/opencode installs)
# --------------------------------------------------
echo ""
echo "--> Restoring nix.conf (flakes support)..."
mkdir -p "$HOME/.config/nix"
cp "$DOTFILES/nix/nix.conf" "$HOME/.config/nix/nix.conf"

# --------------------------------------------------
# 4. Neovim
# --------------------------------------------------
if ! command -v nvim &> /dev/null; then
  echo ""
  echo "--> Installing Neovim via Nix..."
  nix-env -iA nixpkgs.neovim
else
  echo ""
  echo "--> Neovim already installed, skipping."
fi

echo "--> Restoring Neovim config..."
mkdir -p "$HOME/.config/nvim"
cp "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# --------------------------------------------------
# 5. Herdr
# --------------------------------------------------
if ! command -v herdr &> /dev/null; then
  echo ""
  echo "--> Installing Herdr via Nix flake..."
  nix profile add
