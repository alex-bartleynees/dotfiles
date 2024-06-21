#!/bin/bash

# Install lazydocker using curl
if [ -x "$(command -v curl)" ]; then
    echo "Installing lazydocker..."
    sh -c "$(curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash)"
    echo "lazydocker installed successfully!"
else
    echo "curl not found. Please install curl and run this script again."
    exit 1
fi
