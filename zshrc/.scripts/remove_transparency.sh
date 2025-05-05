#!/bin/sh

# ghostty
sed -i \
  -e 's/^\s*\(background-opacity\s*=.*\)/# \1/' \
  -e 's/^\s*\(background-blur\s*=.*\)/# \1/' \
  -e 's/^\s*\(background-blur-radius\s*=.*\)/# \1/' \
  -e 's/^\s*\(alpha-blending\s*=.*\)/# \1/' \
  "$HOME/.config/ghostty/config"

# nvim
FILE="$HOME/.config/nvim/lua/plugins/transparent.lua"
BACKUP="$FILE.old"

# Check if the file exists before renaming
if [ -f "$FILE" ]; then
    mv "$FILE" "$BACKUP"
    echo "Renamed: $FILE → $BACKUP"
else
    echo "File not found: $FILE"
fi
