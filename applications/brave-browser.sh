#!/bin/bash

# Install brave-browser using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "Installing brave-browser on Fedora..."
    sudo dnf install dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install brave-browser
    echo "brave-browser installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing brave-browser on Ubuntu..."
    sudo apt install curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
    echo "brave-browser installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing brave-browser on arch..."
    sudo pacman -Syu brave-browser
    echo "brave browser installed successfully!"
else
    echo "Unsupported package manager. Please install brave-browser manually."
    exit 1
fi


