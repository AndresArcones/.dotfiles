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
    if ! command -v git &> /dev/null; then
        nix profile install nixpkgs#git
    fi
fi

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Clone dotfiles if not already cloned
if [ ! -d ~/.dotfiles ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/AndresArcones/.dotfiles ~/.dotfiles
fi

cd ~/.dotfiles

# Install home-manager
if ! command -v home-manager &> /dev/null; then
    echo "Installing home-manager..."
    nix profile install nixpkgs#home-manager
fi

# Switch to the new configuration
echo "Applying configuration..."
home-manager switch --flake .#default

echo "Setup complete! Enjoy your new Nix-managed environment."
