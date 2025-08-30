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
catppuccin_mocha=' Catppuccin Mocha'
tokyo_night=' Tokyo Night'

# Get current theme from nixos-rebuild
get_current_theme() {
    # Try to get current specialisation from /run/booted-system
    if [[ -L /run/booted-system/specialisation ]]; then
        readlink /run/booted-system/specialisation | xargs basename
    else
        echo "default"
    fi
}

# CMDs
current_theme=$(get_current_theme)
host=$(hostname)
user=$(whoami)

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$user@$host" \
        -mesg "Current theme: $current_theme" \
        -theme "${ROFI_THEME}.rasi"
}

# Build menu options dynamically
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
            *)
                # Generic icon for other themes
                options+=" $(echo $theme | sed 's/-/ /g' | sed 's/\b\w/\U&/g')\n"
                ;;
        esac
    done
    
    echo -e "$options"
}

# Pass variables to rofi dmenu
run_rofi() {
    build_theme_options | rofi_cmd
}

# Switch to theme specialization at runtime (no rebuild)
switch_theme() {
    local theme_name="$1"
    local specialisation_path="/run/booted-system/specialisation/$theme_name"
    
    echo "Switching to theme: $theme_name"
    
    # Check if specialisation exists
    if [[ ! -d "$specialisation_path" ]]; then
        echo "Error: Specialisation '$theme_name' not found at $specialisation_path"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Theme Switch Failed" "Specialisation '$theme_name' not found"
        fi
        return 1
    fi
    
    # Try using systemd-ask-password if available (works well with GUI)
    if command -v systemd-ask-password >/dev/null 2>&1; then
        password=$(systemd-ask-password "Enter password to switch theme:")
        if [[ -n "$password" ]]; then
            if echo "$password" | sudo -S "$specialisation_path/bin/switch-to-configuration" switch >/dev/null 2>&1; then
                echo "Successfully switched to $theme_name theme!"
                if command -v notify-send >/dev/null 2>&1; then
                    notify-send "Theme Switched" "Successfully switched to $theme_name theme"
                fi
            else
                echo "Failed to switch to $theme_name theme"
                if command -v notify-send >/dev/null 2>&1; then
                    notify-send "Theme Switch Failed" "Failed to switch to $theme_name theme"
                fi
            fi
        else
            echo "No password provided"
        fi
    else
        # Fallback: just try regular sudo (will only work from terminal)
        echo "Warning: Running from terminal context, you'll need to enter password"
        if sudo "$specialisation_path/bin/switch-to-configuration" switch; then
            echo "Successfully switched to $theme_name theme!"
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Theme Switched" "Successfully switched to $theme_name theme"
            fi
        else
            echo "Failed to switch to $theme_name theme"
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Theme Switch Failed" "Failed to switch to $theme_name theme"
            fi
        fi
    fi
}

# Map display names to theme names
get_theme_name() {
    case "$1" in
        "$catppuccin_mocha")
            echo "catppuccin-mocha"
            ;;
        "$tokyo_night")
            echo "tokyo-night"
            ;;
        *)
            # For generic themes, convert back from display name
            echo "$1" | sed 's/^ //' | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]'
            ;;
    esac
}

# Actions
chosen="$(run_rofi)"
if [[ -n "$chosen" ]]; then
    theme_name=$(get_theme_name "$chosen")
    
    # Confirm before switching (since this requires sudo)
    if rofi -dmenu -p "Switch to $theme_name theme?" -mesg "This will switch your theme at runtime" \
           -theme "${ROFI_THEME}.rasi" <<< $'Yes\nNo' | grep -q "Yes"; then
        switch_theme "$theme_name"
    fi
fi