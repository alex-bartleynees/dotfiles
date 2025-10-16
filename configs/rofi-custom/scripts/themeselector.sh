#!/usr/bin/env bash

# Theme selector script for rofi - switches NixOS specializations
# Usage: ./themeselector.sh [rofi-theme]
# Available rofi themes: powermenu, powermenu-everforest, powermenu-tokyo-night

# Default rofi theme
ROFI_THEME="${1:-powermenu}"

# NixOS theme specializations directory
THEMES_DIR="$HOME/.config/nix-config/themes"

# Get available themes dynamically from nix-config
get_available_themes() {
    # Find all .nix files in themes directory except default.nix
    find "$THEMES_DIR" -name "*.nix" -not -name "default.nix" -exec basename {} .nix \; | sort
}

# Parse wallpaper path from theme nix file
get_wallpaper_from_theme() {
    local theme_name="$1"
    local theme_file="$THEMES_DIR/$theme_name.nix"
    
    if [[ -f "$theme_file" ]]; then
        grep -A1 'wallpaper\s*=' "$theme_file" | \
        sed -n 's/.*"\([^"]*\)".*/\1/p' | \
        head -1
    fi
}

# Theme icons
catppuccin_mocha='Catppuccin Mocha'
tokyo_night='Tokyo Night'
nord='Nord'
everforest='Everforest'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "" \
        -mesg "Available themes:" \
        -theme "../themes/powermenu/${ROFI_THEME}.rasi"
}

build_theme_options() {
    local options=""
    local available_themes
    available_themes=$(get_available_themes)
    
    for theme in $available_themes; do
        case $theme in
            "catppuccin-mocha")
                options+="$catppuccin_mocha\n"
                ;;
            "tokyo-night")
                options+="$tokyo_night\n"
                ;;
            "nord")
              options+="$nord\n"
              ;;
            "everforest")
              options+="$everforest\n"
              ;;
        esac
    done
    
    echo -e "${options%\\n}"
}

run_rofi() {
    build_theme_options | rofi_cmd
}

switch_theme() {
    local theme_name="$1"
    local specialisation_path="/run/booted-system/specialisation/$theme_name"
    
    echo "Switching to theme: $theme_name"
    
    local wallpaper_path
    wallpaper_path=$(get_wallpaper_from_theme "$theme_name")
    
    if [[ -n "$wallpaper_path" ]]; then
        wallpaper_path="${wallpaper_path/\$\{inputs.dotfiles\}/~/.config/dotfiles}"
        wallpaper_path="${wallpaper_path/#\~/$HOME}"
    fi
    
    if [[ ! -d "$specialisation_path" ]]; then
        echo "Error: Specialisation '$theme_name' not found at $specialisation_path"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Theme Switch Failed" "Specialisation '$theme_name' not found"
        fi
        return 1
    fi
    
    if sudo "$specialisation_path/bin/switch-to-configuration" switch; then
        echo "Successfully switched to $theme_name theme!"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Theme Switched" "Successfully switched to $theme_name theme"
        fi
        
        # Set wallpaper with swww if available and wallpaper path was found
        if [[ -n "$wallpaper_path" ]] && command -v swww >/dev/null 2>&1; then
            echo "Setting wallpaper: $wallpaper_path"
            swww img "$wallpaper_path" &
        fi
        
        # Reload Sway if running under Sway
        if [[ "$XDG_CURRENT_DESKTOP" == "sway" ]] && command -v swaymsg >/dev/null 2>&1; then
            echo "Reloading Sway configuration..."
            swaymsg reload
        fi      

        # Reload River if running under river
        if [[ "$XDG_CURRENT_DESKTOP" == "river" ]]; then
            echo "Reloading River configuration..."
            exec $HOME/.config/river/init
        fi
    else
        echo "Failed to switch to $theme_name theme"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Theme Switch Failed" "Failed to switch to $theme_name theme"
        fi
    fi
}

# Map display names to theme names
get_theme_name() {
    case "$1" in
               *)
            echo "$1" | sed 's/^ //' | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]'
            ;;
    esac
}

# Actions
chosen="$(run_rofi)"
if [[ -n "$chosen" ]]; then
    theme_name=$(get_theme_name "$chosen")
    switch_theme "$theme_name"
fi
