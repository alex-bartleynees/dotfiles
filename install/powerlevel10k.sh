#!/bin/bash

# Install powerlevel10k using git
if [ -x "$(command -v git)" ]; then
    echo "Installing powerlevel10k..."
    sh -c "$(git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k)"
    echo "powerlevel10k installed successfully!"
else
    echo "git not found. Please install git and run this script again."
    exit 1
fi

