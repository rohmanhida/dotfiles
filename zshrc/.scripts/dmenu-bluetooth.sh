#!/bin/bash
# ~/.local/bin/bluetooth-menu

devices=$(bluetoothctl devices | cut -d' ' -f2-)

chosen=$(echo "$devices" | fuzzel --dmenu --prompt="Bluetooth: ")

if [ -n "$chosen" ]; then
    mac=$(bluetoothctl devices | grep "$chosen" | awk '{print $2}')
    bluetoothctl connect "$mac"
fi
