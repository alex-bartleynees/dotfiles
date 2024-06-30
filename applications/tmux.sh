
#!/bin/bash

# Install tmux using dnf or apt or pacman
if [ -x "$(command -v dnf)" ]; then
    echo "Installing tmux on Fedora..."
    sudo dnf install tmux
    echo "tmux installed successfully!"
elif [ -x "$(command -v apt)" ]; then
    echo "Installing tmux on Ubuntu..."
    sudo apt update
    sudo apt install tmux
    echo "tmux installed successfully!"
elif [ -x "$(command -v pacman)" ]; then
    echo "installing tmux on arch..."
    sudo pacman -S tmux
    echo "tmux installed successfully!"
else
    echo "Unsupported package manager. Please install tmux manually."
    exit 1
fi

