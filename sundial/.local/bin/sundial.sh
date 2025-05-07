#!/bin/bash

# API endpoint for sunrise and sunset times
API_URL="https://api.sunrisesunset.io/json?lat=-7.17520&lng=112.63382&time_format=24"

# Fetch the sunrise and sunset times from the API
response=$(curl -s $API_URL)

# Extract sunrise and sunset times
sunrise=$(echo $response | jq -r '.results.sunrise')
sunset=$(echo $response | jq -r '.results.sunset')

# Get the current hour
current_time=$(date +'%H:%M:%S')

time_to_seconds() {
  local time=$1
  echo $(date -d "1970-01-01 $time UTC" +%s)
}

# Convert sunrise, sunset, and current time to seconds since midnight
sunrise_seconds=$(time_to_seconds "$sunrise")
sunset_seconds=$(time_to_seconds "$sunset")
current_seconds=$(time_to_seconds "$current_time")

# Get current theme
current=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")
echo $current

# function to set things to light
set_light() {
  if [[ $current == "prefer-light" ]]; then
    echo "already light"
  else
    # bat (automatic)
    # waybar (automatic)
    # tmux
    sed -i 's/dark/light/g' ~/.tmux.conf
    tmux source-file ~/.tmux.conf
    # nvim
    sed -i 's/dark/light/g' ~/.config/nvim/lua/plugins/everforest.lua
    # rofi
    sed -i '0,/dark/s/dark/light/' ~/.config/rofi/config.rasi
    # hyprland
    sed -i 's/dark/light/g' ~/.config/hypr/hyprland.conf
    # starship
    sed -i '0,/dark/s/dark/light/' ~/.config/starship.toml
    # swaync
    cat ~/.config/swaync/style-light.css > ~/.config/swaync/style.css
    swaync-client -rs
    # hyprlock
    sed -i 's/kendal-unsplash.jpg/benjamin-unsplash.jpg/g' ~/.config/hypr/hyprlock.conf
    sed -i 's/dark/light/g' ~/.config/hypr/hyprlock.conf
    # GTK
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
  fi
}

# function to set things to dark
set_dark() {
  # hyprpaper
  if [[ $current == "prefer-dark" ]]; then
    echo "already dark"
  else
    # bat (automatic)
    # waybar (automatic)
    # tmux
    sed -i 's/light/dark/g' ~/.tmux.conf
    tmux source-file ~/.tmux.conf
    # nvim
    sed -i 's/light/dark/g' ~/.config/nvim/lua/plugins/everforest.lua
    # rofi
    sed -i '0,/light/s/light/dark/' ~/.config/rofi/config.rasi
    # hyprland
    sed -i 's/light/dark/g' ~/.config/hypr/hyprland.conf
    # starship
    sed -i '0,/light/s/light/dark/' ~/.config/starship.toml
    # swaync
    cat ~/.config/swaync/style-dark.css > ~/.config/swaync/style.css
    swaync-client -rs
    # hyprlock
    sed -i 's/benjamin-unsplash.jpg/kendal-unsplash.jpg/g' ~/.config/hypr/hyprlock.conf
    sed -i 's/light/dark/g' ~/.config/hypr/hyprlock.conf
    # GTK
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
  fi
}


if [ -z "$1" ]; then
  echo "Argument is empty"
else
  echo "Argument is: $1"
fi

if [ ! -z "$1" ] && [ "$1" = "manual" ]; then
  if [ "$current" = "prefer-dark" ]; then
    set_light
  else
    set_dark
  fi
else
  # Compare current time to sunrise and sunset times
  if (( current_seconds >= sunrise_seconds && current_seconds <= sunset_seconds )); then
    # set_light
    set_dark
  else
    set_dark
  fi
fi
