#!/bin/sh

# hyprland
cat ~/.cache/wal/colors-hyprland.conf > ~/.config/hypr/colors/pywal.conf
hyprctl reload
# kitty
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/light-theme.auto.conf
cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/dark-theme.auto.conf
# zshrc
# sed -i -e 's/^# cat ~\/.cache\/wal\/sequences$/cat ~\/.cache\/wal\/sequences/' -e 's/^# source ~\/.cache\/wal\/colors-tty\.sh$/source ~\/.cache\/wal\/colors-tty.sh/' ~/.zshrc
# ghostty
# bat
cat ~/.cache/wal/colors-bat.tmTheme > ~/.config/bat/themes/pywal.tmTheme
sed -i "s/^--theme-light=\".*\"/--theme-light=\"pywal\"/" ~/.config/bat/config
sed -i "s/^--theme-dark=\".*\"/--theme-dark=\"pywal\"/" ~/.config/bat/config
bat cache --build
# waybar
# tmux
sed -i "s|source ~/.tmux/.*\.tmux.conf|source ~/.tmux/pywal.tmux.conf|" ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
(cat ~/.cache/wal/sequences &)
# nvim
sed -i '64s/light/dark/g' ~/.config/nvim/lua/plugins/colorscheme.lua
sed -i "s/vim\.cmd\.colorscheme(\".*\")/vim.cmd.colorscheme(\"pywal16\")/" ~/.config/nvim/lua/plugins/colorscheme.lua
sed -i 's/theme = "auto",/theme = "pywal16-nvim",/' ~/.config/nvim/lua/plugins/lualine.lua
# vim
# yazi
# rofi
# starship
# swaync
# le script
sed -i "s|--preview 'bat --theme=\"[^\"]*\"|--preview 'bat --theme=\"pywal\"|g" ~/.scripts/fzf_listoldfiles.sh
