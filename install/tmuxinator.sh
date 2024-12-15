 #!/bin/bash

# Install tmux and ruby if not already installed
sudo pacman -S --noconfirm tmux ruby

# Install tmuxinator
gem install --user-install tmuxinator

# Create config directory
mkdir -p ~/.config/tmuxinator
