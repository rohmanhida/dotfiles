#!/bin/sh

CURRENT_PLAYER=$(playerctl metadata --format='{{playerName}}')
CURRENT_STATUS=$(playerctl status)

if [ "$CURRENT_PLAYER" == "spotify" ]; then
  icon=''
elif [ "$CURRENT_PLAYER" == "firefox" ]; then
  icon=''
else
  icon=''
fi

if [ "$CURRENT_STATUS" == "Playing" ]; then
  status=''
elif [ "$CURRENT_STATUS" == "Paused" ]; then
  status=''
else
  status=''
  icon=''
fi

echo "${icon}   $(playerctl metadata --format='{{ artist }} - {{ title }}')"
