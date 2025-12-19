#!/bin/bash
# Bootstrap script for Nix-based dotfiles on Ubuntu
# Usage: curl -fsSL <url> | bash

set -e

echo "Setting up Nix-based dotfiles..."

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    wget -qO- https://nixos.org/nix/install | sh
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Enable flakes
mkdir -p ~/.config/nix
grep -q "experimental-features" ~/.config/nix/nix.conf || \
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Install git temporarily for cloning and flake operations
nix profile add nixpkgs#git

# Clone dotfiles if not already cloned
if [ ! -d ~/.dotfiles ]; then
    echo "Cloning dotfiles..."
    git clone --recurse-submodules https://github.com/AndresArcones/.dotfiles ~/.dotfiles
fi

cd ~/.dotfiles

# Apply Home Manager configuration
echo "Applying Home Manager configuration..."
if nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres'; then
    echo "Home Manager switch successful"
else
    echo "Switch failed, retrying after removing temporary git..."
    nix profile remove git
    nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres'
fi

# Remove the temporary git install
nix profile remove git

# Ensure i3 shows up in GDM/LightDM login screen
SESSION_FILE="/usr/share/xsessions/i3.desktop"
if [ ! -f "$SESSION_FILE" ]; then
    echo "Creating i3 desktop session for login screen..."
    sudo tee "$SESSION_FILE" > /dev/null <<EOF
[Desktop Entry]
Name=i3
Comment=Dynamic tiling window manager
Exec=$HOME/.nix-profile/bin/i3
Type=XSession
TryExec=$HOME/.nix-profile/bin/i3
EOF
fi

echo "Setup complete! You can now choose Ubuntu or i3 at the login screen."
