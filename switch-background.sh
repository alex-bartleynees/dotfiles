#!/bin/bash

if [ $# -eq 0 ]; then
  echo "$0: Please provide the path to the backgrounds directory"
  exit 1
fi

# Path to the backgrounds directory provided as argument
BACKGROUNDS_DIR="$1"
SWAY_BG_FILE="/home/alexbn/.config/sway/background"  # Path to your config file
LOGIN_BG_FILE="/usr/share/sddm/themes/catppuccin-mocha/theme.conf"
ENV_FILE="/home/alexbn/.zshenv"

# Ensure the backgrounds directory exists
if [ ! -d "$BACKGROUNDS_DIR" ]; then
  echo "Backgrounds directory not found at $BACKGROUNDS_DIR"
  exit 1
fi

# Function to prompt user to select a background
select_background() {
  local backgrounds=("$BACKGROUNDS_DIR"/*)
  local background_count=${#backgrounds[@]}

  if [ $background_count -eq 0 ]; then
    echo "No backgrounds found in $BACKGROUNDS_DIR"
    return 1
  fi

  echo "Select a background:"
  for i in "${!backgrounds[@]}"; do
    echo "[$i] ${backgrounds[$i]}"
  done

  read -p "Enter the number of the background you want to select: " bg_choice

  if [[ ! $bg_choice =~ ^[0-9]+$ ]] || [ $bg_choice -ge $background_count ]; then
    echo "Invalid selection."
    return 1
  fi

  SELECTED_BACKGROUND="${backgrounds[$bg_choice]}"
  echo "Selected background: $SELECTED_BACKGROUND"
}

# Prompt user to select a background
if ! select_background; then
  exit 1
fi

# Ensure the config file exists
if [ ! -f "$SWAY_BG_FILE" ]; then
  echo "Config file not found at $SWAY_BG_FILE"
  exit 1
fi

sed -i "s|^set \$background .*|set \$background $SELECTED_BACKGROUND|" "$SWAY_BG_FILE"
sed -i "s|^export BACKGROUND=.*|export BACKGROUND=$SELECTED_BACKGROUND|" "$ENV_FILE"

# Extract filename from path
filename=$(basename "$SELECTED_BACKGROUND")
sudo sed -i "s|^Background=\".*/\([^/]*\)\"|Background=\"./backgrounds/$filename\"|" "$LOGIN_BG_FILE"

echo "Updated background to $SELECTED_BACKGROUND in $SWAY_BG_FILE"
