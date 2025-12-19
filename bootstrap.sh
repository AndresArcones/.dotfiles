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

# Install git temporarily for cloning and flake operations
nix profile add nixpkgs#git

# Clone dotfiles if not already cloned
if [ ! -d ~/.dotfiles ]; then
    echo "Cloning dotfiles..."
    git clone --recurse-submodules https://github.com/AndresArcones/.dotfiles ~/.dotfiles
fi

cd ~/.dotfiles

# Switch to the new configuration
echo "Applying configuration..."
if nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres'; then
    echo "Switch successful"
else
    echo "Switch failed, removing conflicting git and retrying..."
    nix profile remove git
    nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres'
fi

# Remove the temporary git install
nix profile remove git

echo "Setup complete! Enjoy your new Nix-managed environment."
