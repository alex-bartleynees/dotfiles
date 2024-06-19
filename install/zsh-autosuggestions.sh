#!/bin/bash

# Install zsh autosuggestions using git
if [ -x "$(command -v git)" ]; then
    echo "Installing zsh autosuggestions..."
    sh -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)"
    echo "zsh autosuggestions installed successfully!"
else
    echo "git not found. Please install git and run this script again."
    exit 1
fi

