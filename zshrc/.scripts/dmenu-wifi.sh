#!/bin/bash
# ~/.local/bin/wifi-menu

# Get list of available networks
networks=$(nmcli -f SSID dev wifi list | tail -n +2 | sed 's/^[ \t]*//')

# Let user select
chosen=$(echo "$networks" | fuzzel --dmenu --prompt="WiFi: ")

# Connect to selected network
[ -n "$chosen" ] && nmcli dev wifi connect "$chosen"
