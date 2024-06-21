#!/bin/bash

# Install neovim using dnf or apt
if [ -x "$(command -v dnf)" ]; then
    echo "Installing neovim on Fedora..."
    sudo dnf install -y neovim python3-neovim
    echo "neovim installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing neovim on Ubuntu..."
    sudo apt update
    sudo apt install neovim
    echo "neovim installed successfully!"
else
    echo "Unsupported package manager. Please install neovim manually."
    exit 1
fi


