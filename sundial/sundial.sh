# !/bin/bash

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

# function to set things to light
set_light() {
  # hyprpaper
  echo "changing wallpaper to light"
  WALLPAPER=$(ls ~/wallpapers/light | shuf -n 1)
  hyprctl hyprpaper preload "~/wallpapers/light/$WALLPAPER"
  hyprctl hyprpaper wallpaper ",~/wallpapers/light/$WALLPAPER"
  if [[ $current == "prefer-light" ]]; then
    echo "already light"
  else
    # kitty
    sed -i 's/main/dawn/g' ~/.config/kitty/kitty.conf
    # tmux
    sed -i 's/main/dawn/g' ~/.tmux.conf
    # starship
    cat ~/.config/starship/rose-pine-dawn.toml > ~/.config/starship.toml
    # hyprland
    sed -i 's/rose-pine-main/rose-pine-dawn/g' ~/.config/hypr/hyprland.conf
    # rofi
    sed -i 's/rose-pine-main/rose-pine-dawn/g' ~/.config/rofi/launchers/type-4/shared/colors.rasi
    # swaync
    cat ~/.config/swaync/rose-pine-dawn.css > ~/.config/swaync/style.css
    swaync-client -rs
    # hyprlock
    sed -i 's/kendal-unsplash.jpg/bird.jpg/g' ~/.config/hypr/hyprlock.conf
    sed -i 's/dark/light/g' ~/.config/hypr/hyprlock.conf
    # spicetify
    # GTK
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
  fi
}

# function to set things to dark
set_dark() {
  # hyprpaper
  echo "changing wallpaper to dark"
  WALLPAPER=$(ls ~/wallpapers/dark | shuf -n 1)
  hyprctl hyprpaper preload "~/wallpapers/dark/$WALLPAPER"
  hyprctl hyprpaper wallpaper ",~/wallpapers/dark/$WALLPAPER"

  if [[ $current == "prefer-dark" ]]; then
    echo "already dark"
  else
    # kitty
    sed -i 's/dawn/main/g' ~/.config/kitty/kitty.conf
    # tmux
    sed -i 's/dawn/main/g' ~/.tmux.conf
    # starship
    cat ~/.config/starship/rose-pine-main.toml > ~/.config/starship.toml
    # hyprland
    sed -i 's/rose-pine-dawn/rose-pine-main/g' ~/.config/hypr/hyprland.conf
    # rofi
    sed -i 's/rose-pine-dawn/rose-pine-main/g' ~/.config/rofi/launchers/type-4/shared/colors.rasi
    # swaync
    cat ~/.config/swaync/rose-pine-main.css > ~/.config/swaync/style.css
    swaync-client -rs
    # hyprlock
    sed -i 's/bird.jpg/kendal-unsplash.jpg/g' ~/.config/hypr/hyprlock.conf
    sed -i 's/light/dark/g' ~/.config/hypr/hyprlock.conf
    # spicetify
    # GTK
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  fi
}

if [ -z "$1" ] || [ "$1" = "manual" ]; then
  if [ "$current" = "prefer-dark" ]; then
    set_light
  else
    set_dark
  fi
else
  # Compare current time to sunrise and sunset times
  if (( current_seconds >= sunrise_seconds && current_seconds <= sunset_seconds )); then
    set_light
  else
    set_dark
  fi
fi
