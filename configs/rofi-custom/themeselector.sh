#!/usr/bin/env bash

# Theme selector script for rofi - switches NixOS specializations
# Usage: ./themeselector.sh [rofi-theme]
# Available rofi themes: powermenu, powermenu-everforest, powermenu-tokyo-night

# Default rofi theme
ROFI_THEME="${1:-powermenu}"

# NixOS theme specializations directory
THEMES_DIR="/home/alexbn/.config/nix-config/core/themes"

# Get available themes dynamically from nix-config
get_available_themes() {
    # Find all .nix files in themes directory except default.nix
    find "$THEMES_DIR" -name "*.nix" -not -name "default.nix" -exec basename {} .nix \; | sort
}

# Theme icons
catppuccin_mocha='Catppuccin Mocha'
tokyo_night='Tokyo Night'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "" \
        -theme "${ROFI_THEME}.rasi"
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
        
        if [[ -n "$BACKGROUND" ]] && command -v swww >/dev/null 2>&1; then
            (sleep 3 && swww img "$BACKGROUND") &
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
