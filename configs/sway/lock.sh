#!/bin/sh
set -e

# Turn off screen blanking
swaymsg "output * dpms on"

# Run swaylock
swaylock -i ~/dotfiles/backgrounds/Clearnight.png -u --ignore-empty-password --show-failed-attempts

# Re-enable DPMS settings after unlocking
swaymsg "output * dpms on"
