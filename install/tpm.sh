#!/bin/bash

# Install tpm using git
if [ -x "$(command -v git)" ]; then
    echo "Installing tpm..."
    sh -c "$(git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm)"
    echo "tpm installed successfully!"
else
    echo "git not found. Please install git and run this script again."
    exit 1
fi

