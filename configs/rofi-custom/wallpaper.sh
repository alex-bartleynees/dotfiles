#!/bin/sh

WallDir=${1:-~/.config/dotfiles/backgrounds}

PREVIEW=true \
rofi -no-config -theme fullscreen-preview-custom.rasi \
    -show filebrowser -filebrowser-command 'swww img' \
    -filebrowser-directory "$WallDir" \
    -filebrowser-sorting-method mtime \
    -selected-row 1 >/dev/null