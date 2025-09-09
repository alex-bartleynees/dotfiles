#!/bin/bash

WM=${1:-hyprland}
THEME=${2:-tokyo-night}
BUILD_DIR=${3:-./build}

mkdir -p "$BUILD_DIR"

jq -s '.[0] * .[1] * .[2]' \
    base/common.json \
    "wm/${WM}.json" \
    "themes/${THEME}/config.json" \
    > "${BUILD_DIR}/config.json"

cp "themes/${THEME}/style.css" "${BUILD_DIR}/style.css"

echo "Built config for ${WM} with ${THEME} theme"