#!/bin/sh
export SWAYSOCK=/run/user/1000/sway-ipc.$(id -u).$(pgrep -x sway).sock
export WAYLAND_DISPLAY=wayland-1
set -e

# Turn off screen blanking
swaymsg "output * dpms on"

# Run swaylock
swaylock -i $BACKGROUND

# Re-enable DPMS settings after unlocking
swaymsg "output * dpms on"





