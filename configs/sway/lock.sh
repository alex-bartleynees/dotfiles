#!/bin/sh
set -e

# Turn off screen blanking
swaymsg "output * dpms on"

# Run swaylock
swaylock -i $BACKGROUND

# Re-enable DPMS settings after unlocking
swaymsg "output * dpms on"





