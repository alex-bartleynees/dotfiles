#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-1"
theme='style-4'

# CMDs
uptime="$(awk '{print int($1/86400)"d "int($1%86400/3600)"h "int(($1%3600)/60)"m"}' /proc/uptime)"
host=`hostname`

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'
yes=' Yes'
no=' No'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-mesg "Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
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
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        compositor="$(get_compositor)"
        
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            case "$compositor" in
                "hyprland")
                    hyprctl dispatch exit
                    ;;
                "sway")
                    killall sway
                    ;;
                *)
                    echo "Unknown compositor, cannot logout"
                    exit 1
                    ;;
            esac
        fi
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
