#!/bin/bash

# install ripgrep using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "installing ripgrep on fedora..."
    sudo dnf install ripgrep
    echo "ripgrep installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "installing ripgrep on ubuntu..."
    sudo apt update
    sudo apt install ripgrep
    echo "ripgrep installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing ripgrep on arch..."
    sudo pacman -syu ripgrep
    echo "ripgrep installed successfully!"
else
    echo "unsupported package manager. please install ripgrep manually."
    exit 1
fi

