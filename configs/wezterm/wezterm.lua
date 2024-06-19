local wezterm = require("wezterm")

local config = {
  macos_window_background_blur = 30,
  enable_tab_bar = false,
  window_decorations = "NONE",
  window_close_confirmation = "NeverPrompt",
  native_macos_fullscreen_mode = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_frame = {
    active_titlebar_bg = '#000000',
  },
  -- font config
  font = wezterm.font({ weight = "Regular", family = 'JetBrains Mono' }),

  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  font_size = 14,
  line_height = 1,
  adjust_window_size_when_changing_font_size = false,

  -- keys config
  send_composed_key_when_left_alt_is_pressed = true,
  send_composed_key_when_right_alt_is_pressed = false,
}


config.color_scheme = 'Molokai (Gogh)'
config.window_background_opacity = 0.85


return config
