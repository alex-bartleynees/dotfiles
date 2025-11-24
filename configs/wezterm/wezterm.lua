local wezterm = require("wezterm")

local config = {
  macos_window_background_blur = 30,
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  native_macos_fullscreen_mode = true,
  default_domain = 'WSL:NixOS',
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_frame = {
    active_titlebar_bg = '#000',
  },

  -- font config
  font = wezterm.font({ weight = "Regular",  family = 'JetBrainsMono Nerd Font'}),
  
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0'  },
  font_size = 12,
  line_height = 1,
  adjust_window_size_when_changing_font_size = false,

  -- keys config
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
}


  config.color_scheme = 'Catppuccin Mocha'
  config.window_background_opacity = 1


return config
