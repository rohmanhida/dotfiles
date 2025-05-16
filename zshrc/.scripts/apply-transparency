#!/bin/sh

source ~/.scripts/customization

FILE="$HOME/.config/nvim/lua/plugins/transparent.lua"
BACKUP="$FILE.old"

if [[ $TRANSPARENT == false ]]; then
  echo "disabling transparency..."
  # ghostty
  sed -i \
    -e 's/^\s*\(background-opacity\s*=.*\)/# \1/' \
    -e 's/^\s*\(background-blur\s*=.*\)/# \1/' \
    -e 's/^\s*\(background-blur-radius\s*=.*\)/# \1/' \
    -e 's/^\s*\(alpha-blending\s*=.*\)/# \1/' \
    "$HOME/.config/ghostty/config"

  # nvim
  # Check if the file exists before renaming
  if [ -f "$FILE" ]; then
      mv "$FILE" "$BACKUP"
      echo "Renamed: $FILE → $BACKUP"
  else
      echo "File not found: $FILE"
  fi

  # lualine
  sed -i \
  -e "/require('transparent')/{
    /^[[:space:]]*--/!s/^\([[:space:]]*\)\(require('transparent').clear_prefix('lualine')\)/\1-- \2/
  }" \
  "$HOME/.config/nvim/lua/plugins/lualine.lua"

else
  echo "enabling transparency..."
  # ghostty
  sed -i \
    -e 's/^\s*#\s*\(background-opacity\s*=.*\)/\1/' \
    -e 's/^\s*#\s*\(background-blur\s*=.*\)/\1/' \
    -e 's/^\s*#\s*\(background-blur-radius\s*=.*\)/\1/' \
    -e 's/^\s*#\s*\(alpha-blending\s*=.*\)/\1/' \
    "$HOME/.config/ghostty/config"
  # nvim

  # Check if the file exists before renaming
  if [ -f "$BACKUP" ]; then
      mv "$BACKUP" "$FILE"
      echo "Renamed: $BACKUP → $FILE"
  else
      echo "File not found: $BACKUP"
  fi

  # lualine
  sed -i \
    -e "s/^\([[:space:]]*\)--[[:space:]]*\(require('transparent').clear_prefix('lualine')\)/\1\2/" \
    "$HOME/.config/nvim/lua/plugins/lualine.lua"
fi
