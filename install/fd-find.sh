#!/bin/bash

# Install fd-find using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "Installing fd-find on Fedora..."
    sudo dnf install fd-find
    echo "fd-find installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing fd-find on Ubuntu..."
    sudo apt update
    sudo apt install fd-find
    echo "fd-find installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing fd-find on arch..."
    sudo pacman -Syu fd-find
    echo "fd-find installed successfully!"
else
    echo "Unsupported package manager. Please install fd-find manually."
    exit 1
fi

