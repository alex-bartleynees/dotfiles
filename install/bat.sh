#!/bin/bash

# install bat using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "installing bat on fedora..."
    sudo dnf install bat
    echo "bat installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "installing bat on ubuntu..."
    sudo apt update
    sudo apt install bat
    echo "bat installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing bat on arch..."
    sudo pacman -S bat
    echo "bat installed successfully!"
else
    echo "unsupported package manager. please install bat manually."
    exit 1
fi

