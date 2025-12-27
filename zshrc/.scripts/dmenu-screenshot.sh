#!/bin/bash
# ~/.local/bin/screenshot-menu

options="Full Screen\nSelect Area\nCurrent Window"

chosen=$(echo -e "$options" | fuzzel --dmenu --prompt="Screenshot: ")

case "$chosen" in
    "Select Area") 
        niri msg action screenshot ;;
    "Full screen") 
        niri msg action screenshot-screen ;;
    "Current Window") 
        niri msg action screenshot-window ;;
esac
