#!/bin/bash

# Bootstrap script for Nix-based dotfiles
# Usage: curl -fsSL <url> | bash

set -e

echo "Setting up Nix-based dotfiles..."

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    wget -qO - https://nixos.org/nix/install | sh
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Clone dotfiles if not already cloned
if [ ! -d ~/.dotfiles ]; then
    echo "Cloning dotfiles..."
    nix run nixpkgs#git -- clone --recurse-submodules https://github.com/AndresArcones/.dotfiles ~/.dotfiles
fi

cd ~/.dotfiles

# Ensure submodule paths are tracked by Git
git add i3/.config/i3 kitty/.config/kitty nvim/.config/nvim tmux/.config/tmux wezterm/.config/wezterm

# Install home-manager
if ! command -v home-manager &> /dev/null; then
    echo "Installing home-manager..."
    nix profile add nixpkgs#home-manager
fi

# Switch to the new configuration
echo "Applying configuration..."
home-manager switch --flake '.?submodules=1#andres'

echo "Setup complete! Enjoy your new Nix-managed environment."
