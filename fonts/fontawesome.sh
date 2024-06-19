##!/bin/bash

# install fontawesome-fonts using dnf
if [ -x "$(command -v dnf)" ]; then
    echo "installing fontawesome-fonts on fedora..."
    sudo dnf install fontawesome-fonts
    echo "fontawesome-fonts installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "installing fontawesome-fonts on ubuntu..."
    sudo apt update
    sudo apt install fontawesome-fonts
    echo "fontawesome-fonts installed successfully!"
else
    echo "unsupported package manager. please install fontawesome-fonts manually."
    exit 1
fi



