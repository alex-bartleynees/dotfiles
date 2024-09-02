#!/bin/sh
set -e
xset s off dpms 0 10 0
i3lock -i ~/dotfiles/backgrounds/lockscreen_composite.png -u --ignore-empty-password --show-failed-attempts --nofork
xset s off -dpms
exec xrandr --output DP-4 --rotate right --right-of DP-0 --auto
