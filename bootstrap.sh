#!/bin/bash

# Bootstrap script for Nix-based dotfiles
# Usage: curl -fsSL <url> | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


echo "Setting up Nix-based dotfiles..."

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    wget -qO- https://nixos.org/nix/install | sh
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

# Apply Home Manager configuration
echo "Applying Home Manager configuration..."
if nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres.arconescrespo'; then
    echo "Switch successful"
else
    echo "Switch failed, retrying after removing temporary git..."
    nix profile remove git
    nix run 'github:nix-community/home-manager' -- switch --flake '.?submodules=1#andres.arconescrespo'
fi

# Remove temporary git
nix profile remove git

# change shell to zsh. nix does not allow it....
echo "/home/andres.arconescrespo/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
echo -e "${YELLOW}⚠️ Run manually to change defualt shell:${NC} ${GREEN}chsh -s /home/andres.arconescrespo/.nix-profile/bin/zsh${NC}"

#install sdk man
curl -s "https://get.sdkman.io" | bash

echo "Setup complete! i3 is ready. You can choose Ubuntu/GNOME or i3 at login."
