#!/bin/bash

# Install nvm using curl
if [ -x "$(command -v curl)" ]; then
    echo "Installing nvm..."
    sh -c "$(curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash)"
    nvm install --lts
    echo "nvm installed successfully!"
else
    echo "curl not found. Please install curl and run this script again."
    exit 1
fi
