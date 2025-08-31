#!/bin/sh

# Usage: wallpaper.sh [theme] [wallpaper_dir]
# Themes: catppuccin-mocha, tokyo-night, everforest

THEME=${1:-catppuccin-mocha}
WallDir=${2:-~/.config/dotfiles/backgrounds}

# Map theme name to theme file
get_theme_file() {
    case "$1" in
        "catppuccin-mocha"|"mocha")
            echo "fullscreen-preview-catppuccin-mocha.rasi"
            ;;
        "tokyo-night"|"tokyo")
            echo "fullscreen-preview-tokyo-night.rasi"
            ;;
        "everforest"|"forest")
            echo "fullscreen-preview-everforest.rasi"
            ;;
        *)
            echo "fullscreen-preview-catppuccin-mocha.rasi"
            ;;
    esac
}

THEME_FILE=$(get_theme_file "$THEME")

PREVIEW=true \
rofi -no-config -theme "$THEME_FILE" \
    -show filebrowser -filebrowser-command 'swww img' \
    -filebrowser-directory "$WallDir" \
    -filebrowser-sorting-method mtime \
    -selected-row 1 >/dev/null