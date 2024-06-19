#!/bin/bash

# Install jetbrainsmono using wget
if [ -x "$(command -v wget)" ]; then
    echo "Installing powerlevel10k..."
    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip \
    && cd ~/.local/share/fonts \
    && unzip JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv
    echo "powerlevel10k installed successfully!"
else
    echo "git not found. Please install git and run this script again."
    exit 1
fi


