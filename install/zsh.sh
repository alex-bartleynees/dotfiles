#!/bin/bash

# Install Oh My Zsh using curl
if [ -x "$(command -v curl)" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh installed successfully!"
else
    echo "curl not found. Please install curl and run this script again."
    exit 1
fi

