#!/bin/bash

# Install fzf using dnf or apt
if [ -x "$(command -v dnf)" ]; then
    echo "Installing fzf on Fedora..."
    sudo sudo dnf install fzf
    echo "fzf installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing fzf on Ubuntu..."
    sudo apt install -y zsh-syntax-highlighting
    echo "fzf installed successfully!"
else
    echo "Unsupported package manager. Please install fzf manually."
    exit 1
fi

