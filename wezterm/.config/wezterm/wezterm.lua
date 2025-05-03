-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Nord'
config.enable_wayland = false
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_background_opacity = 0.3

return config
