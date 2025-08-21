#!/usr/bin/env bash

# Power menu script for rofi - compatible with Hyprland, Sway, and other tiling WMs
# Usage: ./powermenu.sh [theme]
# Available themes: powermenu, powermenu-everforest, powermenu-tokyo-night

# Default theme
THEME="${1:-powermenu}"

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'

# CMDs
uptime="$(awk '{print int($1/86400)"d "int($1%86400/3600)"h "int(($1%3600)/60)"m"}' /proc/uptime)"
host=`hostname`
user=$(whoami)

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
  -p "$user@$host" \
		-mesg "Uptime: $uptime" \
    -theme "${THEME}.rasi"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | rofi_cmd
}

# Detect current compositor
get_compositor() {
    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        echo "hyprland"
    elif [[ "$XDG_CURRENT_DESKTOP" == "sway" ]] || pgrep -x sway > /dev/null; then
        echo "sway"
    else
        echo "unknown"
    fi
}

# Execute Command
run_cmd() {
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
           loginctl terminate-user ""
        else
            exit 0
        fi
}

# Execute lock command based on compositor
run_lock() {
    compositor="$(get_compositor)"
    case "$compositor" in
        "hyprland")
            hyprlock
            ;;
        "sway")
            if [[ -f ~/.config/dotfiles/configs/sway/lock.sh ]]; then
                ~/.config/dotfiles/configs/sway/lock.sh
            else
                echo "Sway lock script not found"
            fi
            ;;
        *)
            echo "Unknown compositor, cannot lock"
            ;;
    esac
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        run_lock
        ;;
    $suspend)
        run_cmd --suspend
        ;;
    $logout)
        run_cmd --logout
        ;;
esac
