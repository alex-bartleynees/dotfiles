#!/bin/bash

# Exit on error
set -e

echo "Installing grim and dependencies..."
sudo pacman -S --noconfirm \
    grim \
    slurp \
    wl-clipboard

echo "Installation complete!"
