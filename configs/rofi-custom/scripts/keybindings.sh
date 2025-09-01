#!/usr/bin/env bash

# Rofi script to show keybindings from Sway and Hyprland configurations
# Automatically detects current desktop environment via XDG_CURRENT_DESKTOP

set -euo pipefail

# Configuration paths
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
SWAY_CONFIG="$HOME/.config/sway/config"

# Colors for formatting
RESET='\033[0m'
BOLD='\033[1m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'

# Function to parse Hyprland keybindings
parse_hyprland() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Hyprland config not found: $config_file" >&2
        return 1
    fi
    
    # Parse variable definitions first
    local mod_key=""
    local terminal=""
    local browser=""
    local lock=""
    
    while IFS= read -r line; do
        if [[ $line =~ ^\$mod=(.+)$ ]]; then
            mod_key="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^\$terminal=(.+)$ ]]; then
            terminal="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^\$browser=(.+)$ ]]; then
            browser="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^\$lock=(.+)$ ]]; then
            lock="${BASH_REMATCH[1]}"
        fi
    done < "$config_file"
    
    # Default to ALT if not found
    mod_key="${mod_key:-ALT}"
    
    # Parse keybindings
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ $line =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Parse bind statements: bind=$mod, KEY, ACTION, PARAMS
        if [[ $line =~ ^bind[elm]*=(.+)$ ]]; then
            local binding="${BASH_REMATCH[1]}"
            
            # Split by comma and clean up spaces
            IFS=',' read -ra PARTS <<< "$binding"
            
            if [[ ${#PARTS[@]} -ge 3 ]]; then
                local modifier="${PARTS[0]// }"
                local key="${PARTS[1]// }"
                local action="${PARTS[2]// }"
                local params=""
                
                # Combine remaining parts as parameters
                if [[ ${#PARTS[@]} -gt 3 ]]; then
                    params=$(IFS=','; echo "${PARTS[*]:3}")
                    params="${params# }"
                fi
                
                # Combine modifier and key
                local keys="$modifier $key"
                
                # Replace $mod with actual modifier and format keys properly
                keys="${keys//\$mod/$mod_key}"
                keys="${keys// SHIFT/+Shift}"
                keys="${keys// CTRL/+Ctrl}"
                keys="${keys// CONTROL/+Ctrl}"
                keys="${keys//SHIFT/+Shift}"
                keys="${keys//CTRL/+Ctrl}"
                keys="${keys//CONTROL/+Ctrl}"
                
                # Replace variables in action/params
                action="${action//\$terminal/$terminal}"
                action="${action//\$browser/$browser}"
                action="${action//\$lock/$lock}"
                params="${params//\$terminal/$terminal}"
                params="${params//\$browser/$browser}"
                params="${params//\$lock/$lock}"
                
                # Format the output
                local full_action="$action"
                [[ -n "$params" ]] && full_action="$action $params"
                
                printf "%s → %s\n" "$keys" "$full_action"
            fi
        fi
    done < "$config_file"
}

# Function to parse Sway keybindings
parse_sway() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        echo "Sway config not found: $config_file" >&2
        return 1
    fi
    
    local in_resize_mode=false
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ $line =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Check for resize mode
        if [[ $line =~ ^mode[[:space:]]+\"resize\" ]]; then
            in_resize_mode=true
            continue
        elif [[ $line =~ ^}[[:space:]]*$ ]] && $in_resize_mode; then
            in_resize_mode=false
            continue
        fi
        
        # Parse bindsym statements
        if [[ $line =~ ^[[:space:]]*bindsym[[:space:]]+([^[:space:]]+)(.*) ]]; then
            local keys="${BASH_REMATCH[1]}"
            local command="${BASH_REMATCH[2]}"
            
            # Remove leading whitespace from command
            command="${command## }"
            
            # Clean up keys formatting
            keys="${keys//Mod1/ALT}"
            keys="${keys//Control/Ctrl}"
            keys="${keys//+/+}"
            
            # Add prefix for resize mode bindings
            local prefix=""
            if $in_resize_mode; then
                prefix="[Resize] "
            fi
            
            printf "%s → %s%s\n" "$keys" "$prefix" "$command"
        fi
    done < "$config_file"
}

# Function to get current desktop environment
get_current_desktop() {
    # Check XDG_CURRENT_DESKTOP first
    if [[ -n "${XDG_CURRENT_DESKTOP:-}" ]]; then
        echo "${XDG_CURRENT_DESKTOP,,}"
        return 0
    fi
    
    # Fallback: check running processes
    if pgrep -x "Hyprland" > /dev/null; then
        echo "hyprland"
    elif pgrep -x "sway" > /dev/null; then
        echo "sway"
    else
        echo "unknown"
    fi
}

# Function to show keybindings in rofi
show_in_rofi() {
    local desktop="$1"
    local theme="$2"
    local config_file=""
    local title=""
    
    case "$desktop" in
        hyprland|hypr*)
            config_file="$HYPR_CONFIG"
            title="Hyprland Keybindings"
            ;;
        sway|i3*)
            config_file="$SWAY_CONFIG" 
            title="Sway Keybindings"
            ;;
        *)
            echo "Unsupported desktop environment: $desktop" >&2
            exit 1
            ;;
    esac
    
    local temp_file=$(mktemp)
    trap "rm -f $temp_file" EXIT
    
    case "$desktop" in
        hyprland|hypr*)
            parse_hyprland "$config_file" | sort > "$temp_file"
            ;;
        sway|i3*)
            parse_sway "$config_file" | sort > "$temp_file"
            ;;
    esac
    
    if [[ ! -s "$temp_file" ]]; then
        echo "No keybindings found or config file not accessible" >&2
        exit 1
    fi
    
    # Use rofi to display the keybindings with maximum width and height
    rofi -dmenu \
         -i \
         -p "Keybindings" \
         -mesg "$title" \
         -theme "$HOME/.config/rofi/themes/colors/${theme}.rasi" \
         -format "d" \
         -no-custom \
         -window-title "Keybindings" \
         -font "JetBrainsMono Nerd Font 10" \
         -theme-str 'window { width: 70%; height: 80%; }' \
         -theme-str 'listview { columns: 3; lines: 25; }' \
         -theme-str 'element-text { horizontal-align: 0; }' \
         < "$temp_file" > /dev/null
}

# Main function
main() {
    local theme="${1:-tokyo-night}"
    local desktop
    desktop=$(get_current_desktop)
    
    if [[ "$desktop" == "unknown" ]]; then
        echo "Cannot determine current desktop environment" >&2
        echo "Please set XDG_CURRENT_DESKTOP or ensure Sway/Hyprland is running" >&2
        exit 1
    fi
    
    show_in_rofi "$desktop" "$theme"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi