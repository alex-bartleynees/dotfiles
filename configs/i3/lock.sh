#!/bin/sh
set -e
xset s off dpms 0 10 0
i3lock -i ~/dotfiles/backgrounds/lucas-benjamin-unsplash.png -u --ignore-empty-password --show-failed-attempts --nofork
xset s off -dpms