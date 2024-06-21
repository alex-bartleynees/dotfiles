#!/bin/bash

# Install zsh using dnf or apt
if [ -x "$(command -v dnf)" ]; then
    echo "Installing zsh on Fedora..."
    sudo dnf install zsh
    chsh -s $(which zsh)
    echo "zsh installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing zsh on Ubuntu..."
    sudo apt update
    sudo apt-get install zsh
    chsh -s $(which zsh)
    echo "zsh installed successfully!"
else
    echo "Unsupported package manager. Please install zsh manually."
    exit 1
fi
