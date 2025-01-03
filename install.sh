#!/bin/bash

# List of install scripts
INSTALL_SCRIPTS=(
    install/oh-my-zsh.sh
    install/zsh-syntax-highlighting.sh
    install/zsh-autosuggestions.sh
    install/nvm.sh
    install/fzf.sh
    install/fzf-tab.sh
    install/fd-find.sh
    install/bat.sh
    install/ripgrep.sh
    fonts/jetbrainsmono.sh
    fonts/fontawesome.sh
    applications/alacritty.sh
    applications/tmux.sh
    applications/lazydocker.sh
    applications/lazygit.sh
    applications/neovim.sh
    applications/brave-browser.sh
    applications/btm.sh
    install/tpm.sh
)

# Execute each install script
for script in "${INSTALL_SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo "Running $script..."
        bash "$script"
    else
        echo "Script $script not found!"
        exit 1
    fi
done

echo "All packages installed successfully!"
