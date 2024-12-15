#!/bin/bash

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    sudo pacman -S --noconfirm docker
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Install kind
sudo pacman -S --noconfirm kind

# Verify installation
kind version
