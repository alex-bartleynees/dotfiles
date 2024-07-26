#!/bin/bash

if [ $# -eq 0 ]; then
  echo "$0: Please provide a theme"
  exit 1
fi

THEME_NAME="$1"

# Define the source directory (where your selected theme is)
DOTFILES_DIR="/home/alexbn/dotfiles/themes/$THEME_NAME"
ALACRITTY_CONFIG="/home/alexbn/.config/alacritty/alacritty.toml"

sudo ./switch-background.sh "/home/alexbn/dotfiles/themes/$THEME_NAME/backgrounds"

# Function to create symbolic links
create_symlinks() {
    local src_dir=$1
    local dest_dir=$2

    # Ensure the destination directory exists
    sudo mkdir -p "$dest_dir"

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
                sudo rm "$dest_item"
            elif [ -f "$dest_item" ]; then
                echo "Backing up existing $dest_item to $dest_item.bak"
                sudo mv "$dest_item" "$dest_item.bak"
            fi
            echo "Creating symbolic link for $src_item in $dest_dir"
            sudo ln -s "$src_item" "$dest_item"
        fi
    done
}

# List of dot files and their target directories
declare -A DOTFILES
DOTFILES=(
    ["waybar/style.css"]="/home/alexbn/.config/waybar/"
    ["waybar/config.jsonc"]="/home/alexbn/.config/waybar/"
    ["sway/colorscheme"]="/home/alexbn/.config/sway"
    ["rofi/config.rasi"]="/home/alexbn/.config/rofi/"
    ["rofi"/theme.rasi]="/home/alexbn/.config/rofi/"
    ["nvim/colorscheme.lua"]="/home/alexbn/.config/nvim/lua/alex/plugins/"
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
            sudo rm "$dest_file"
        elif [ -f "$dest_file" ]; then
            echo "Backing up existing $dest_file to $dest_file.bak"
            sudo mv "$dest_file" "$dest_file.bak"
        fi

        echo "Creating symbolic link for $src_path in $dest_path"
        sudo ln -s "$src_path" "$dest_file"
    fi
done

# Escape the new theme path for sed
ESCAPED_NEW_THEME=$(echo "$THEME_NAME" | sed 's/[\/&]/\\&/g')

# Update the theme name in the alacritty.toml file
sed -i "s|import = \[\(.*\)\]|import = \[\"/home/alexbn/.config/alacritty/themes/themes/$ESCAPED_NEW_THEME.toml\"\]|" "$ALACRITTY_CONFIG"
echo "Updated theme to $THEME_NAME in alacritty.toml"

echo "Theme installed successfully!"

