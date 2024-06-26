#!/bin/bash

# Install alacritty using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "Installing alacritty on Fedora..."
    sudo dnf install alacritty
    echo "alacritty installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing alacritty on Ubuntu..."
    sudo apt update
    sudo apt install alacritty
    echo "alacritty installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing alacritty on arch..."
    sudo pacman -S alacritty
    echo "alacritty installed successfully!"
else
    echo "Unsupported package manager. Please install alacritty manually."
    exit 1
fi


