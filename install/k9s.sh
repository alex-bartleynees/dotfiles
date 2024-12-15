#!/bin/bash

# Exit on error
set -e

# Check if k9s is already installed
if command -v k9s &> /dev/null; then
    echo "k9s is already installed"
    k9s version
    exit 0
fi

# Install k9s
echo "Installing k9s..."
sudo pacman -S --noconfirm k9s

# Verify installation
echo "Installation complete. Checking version:"
k9s version

