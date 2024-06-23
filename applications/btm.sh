#!/bin/bash

# Install bottom using dnf or apt
if [ -x "$(command -v dnf)" ]; then
    echo "Installing bottom on Fedora..."
    sudo dnf copr enable atim/bottom -y
    sudo dnf install bottom
    echo "bottom installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing bottom on Ubuntu..."
    sudo apt update
    sudo apt install bottom
    echo "bottom installed successfully!"
else
    echo "Unsupported package manager. Please install bottom manually."
    exit 1
fi


