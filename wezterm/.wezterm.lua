local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Liga SFMono Nerd Font'
config.color_scheme = 'GruvboxDark'
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.keys = {
  {
    -- split pane below
    key = '"',
    mods = 'SUPER | SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    -- split pane on the right
    key = '&',
    mods = 'SUPER | SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- move focus to the left pane
  {
    key = 'h',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  -- Move focus to the down pane
  {
    key = 'j',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  -- Move focus to the up pane
  {
    key = 'k',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  -- Move focus to the right pane
  {
    key = 'l',
    mods = 'CTRL | SHIFT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
}

return config
