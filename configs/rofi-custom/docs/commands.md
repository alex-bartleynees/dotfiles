# Rofi Commands

## Theme Usage

### Change theme in config.rasi

```css
@theme "catppuccin-mocha"
@theme "tokyo-night"
@theme "everforest";
```

### Command line usage

```bash
# Application launcher with different themes
rofi -show drun -theme ~/.config/dotfiles/configs/rofi-old/catppuccin-mocha.rasi
rofi -show drun -theme ~/.config/dotfiles/configs/rofi-old/tokyo-night.rasi
rofi -show drun -theme ~/.config/dotfiles/configs/rofi-old/everforest.rasi

# Run launcher
rofi -show run -theme ~/.config/dotfiles/configs/rofi-old/tokyo-night.rasi

# Window switcher
rofi -show window -theme ~/.config/dotfiles/configs/rofi-old/everforest.rasi

# Power menu
~/.config/dotfiles/configs/rofi-old/powermenu.sh
```

## Available Themes

- **catppuccin-mocha** - Purple/blue dark theme
- **tokyo-night** - Dark blue with purple accents
- **everforest** - Warm forest green theme
- **powermenu** - Specialized theme for power menu

## Files

- `config.rasi` - Main rofi configuration
- `*.rasi` - Theme files
- `powermenu.sh` - Power menu script

