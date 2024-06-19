#!/bin/bash

# Install fzf tab using git
if [ -x "$(command -v git)" ]; then
    echo "Installing fzf tab..."
    sh -c "$(git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab)"
    echo "fzf tab installed successfully!"
else
    echo "git not found. Please install git and run this script again."
    exit 1
fi

