#!/bin/bash

# Install zsh syntax highlighting using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "Installing zsh syntax highlighting on Fedora..."
    sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/Fedora_Rawhide/shells:zsh-users:zsh-syntax-highlighting.repo
    sudo dnf install -y zsh-syntax-highlighting
    echo "zsh syntax highlighting installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing zsh syntaxhighlighting on Ubuntu..."
    echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-syntax-highlighting/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-syntax-highlighting.list
    curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-syntax-highlighting.gpg > /dev/null
    sudo apt update
    sudo apt install -y zsh-syntax-highlighting
    echo "zsh syntax highlighting installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing zsh syntax highlighting on arch..."
    sudo pacman -Syu zsh-syntax-highlighting
    echo "zsh syntax highlighting installed successfully!"
else
    echo "Unsupported package manager. Please install zsh syntax highlighting manually."
    exit 1
fi

