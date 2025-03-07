#!/bin/sh

CURRENT_PLAYER=$(playerctl metadata --format='{{playerName}}')
CURRENT_STATUS=$(playerctl status)
CURRENT_SONG=$(playerctl metadata --format='{{title}}')

if [[ "$CURRENT_PLAYER" =~ ^(spotify|ncspot|spotify_player)$ ]]; then
  icon=''
  format='{{ artist }} - {{ title }}'
elif [ "$CURRENT_PLAYER" == "firefox" ]; then
  icon=''
  format='{{ title }}'
elif [ "$CURRENT_PLAYER" == "mpv" ]; then
  icon=''
  format='{{ title }}'
else
  icon=''
  format='{{ title }}'
fi

if [ "$CURRENT_STATUS" == "Playing" ]; then
  status=''
elif [ "$CURRENT_STATUS" == "Paused" ]; then
  status=''
else
  status=''
  icon=''
fi

echo "${icon}   $(playerctl metadata --format="${format}")"
