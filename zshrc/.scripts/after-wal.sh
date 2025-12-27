#!/bin/sh

# Determine which sed to use (GNU vs BSD)
if sed --version >/dev/null 2>&1; then
  # GNU sed
  SED="sed -i"
else
  # BSD sed (macOS)
  SED="sed -i ''"
fi

# kitty
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/light-theme.auto.conf
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/dark-theme.auto.conf

# bat
cat ~/.cache/wal/colors-bat.tmTheme > ~/.config/bat/themes/pywal.tmTheme
$SED "s/^--theme-light=\".*\"/--theme-light=\"pywal\"/" ~/.config/bat/config
$SED "s/^--theme-dark=\".*\"/--theme-dark=\"pywal\"/" ~/.config/bat/config
bat cache --build

# tmux
$SED "s|source ~/.tmux/.*\.tmux.conf|source ~/.tmux/pywal.tmux.conf|" ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
(cat ~/.cache/wal/sequences &)

# nvim
$SED '60s/light/dark/g' ~/.config/nvim/lua/plugins/colorscheme.lua
$SED "s/vim\.cmd\.colorscheme(\".*\")/vim.cmd.colorscheme(\"pywal16\")/" ~/.config/nvim/lua/plugins/colorscheme.lua
$SED 's/theme = "auto",/theme = "pywal16-nvim",/' ~/.config/nvim/lua/plugins/lualine.lua

# yazi, rofi, starship, swaync - add as needed

# le script
$SED "s|--preview 'bat --theme=\"[^\"]*\"|--preview 'bat --theme=\"pywal\"|g" ~/.scripts/fzf_listoldfiles.sh
