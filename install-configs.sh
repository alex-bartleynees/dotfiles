#!/bin/bash

# Define the source directory (where your dot files are)
DOTFILES_DIR="$HOME/dotfiles/configs"

# Function to create symbolic links
create_symlinks() {
    local src_dir=$1
    local dest_dir=$2

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    # Iterate through all files and directories in the source directory
    for item in "$src_dir"/*; do
        local src_item="$item"
        local dest_item="$dest_dir/$(basename "$item")"

        # If the item is a directory, call the function recursively
        if [ -d "$src_item" ]; then
            create_symlinks "$src_item" "$dest_item"
        else
            # If the item is a file, create a symbolic link
            if [ -L "$dest_item" ]; then
                echo "Removing existing symbolic link for $dest_item"
                rm "$dest_item"
            elif [ -f "$dest_item" ]; then
                echo "Backing up existing $dest_item to $dest_item.bak"
                mv "$dest_item" "$dest_item.bak"
            fi
            echo "Creating symbolic link for $src_item in $dest_dir"
            ln -s "$src_item" "$dest_item"
        fi
    done
}

# List of dot files and their target directories
declare -A DOTFILES
DOTFILES=(
    [".zshrc"]="$HOME"
    [".zshenv"]="$HOME"
    [".gitconfig"]="$HOME"
    ["alacritty"]="$HOME/.config/alacritty"
    ["nvim"]="$HOME/.config/nvim"
    ["rofi"]="$HOME/.config/rofi" 
    ["sway"]="$HOME/.config/sway"
    ["tmux"]="$HOME/.config/tmux"
    ["waybar"]="$HOME/.config/waybar"
    ["wezterm"]="$HOME/.config/wezterm"
)

# Create symbolic links for each entry in the DOTFILES array
for file in "${!DOTFILES[@]}"; do
    src_path="$DOTFILES_DIR/$file"
    dest_path="${DOTFILES[$file]}"

    # If the source path is a directory, call the function recursively
    if [ -d "$src_path" ]; then
        create_symlinks "$src_path" "$dest_path"
    else
        # If the source path is a file, create a symbolic link directly
        dest_file="$dest_path/$(basename "$src_path")"

        if [ -L "$dest_file" ]; then
            echo "Removing existing symbolic link for $dest_file"
            rm "$dest_file"
        elif [ -f "$dest_file" ]; then
            echo "Backing up existing $dest_file to $dest_file.bak"
            mv "$dest_file" "$dest_file.bak"
        fi

        echo "Creating symbolic link for $src_path in $dest_path"
        ln -s "$src_path" "$dest_path"
    fi
done

echo "Dot files installed successfully!"
