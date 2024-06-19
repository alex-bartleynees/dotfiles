
#!/bin/bash

# Install nvm using curl
if [ -x "$(command -v curl)" ]; then
    echo "Installing nvm..."
    sh -c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash)"
    nvm install --lts
    echo "nvm installed successfully!"
else
    echo "curl not found. Please install curl and run this script again."
    exit 1
fi
