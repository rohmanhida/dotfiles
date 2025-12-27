#!/bin/bash
# ~/.local/bin/power-menu

options="Shutdown\nReboot\nSuspend\nLogout\nLock"

chosen=$(echo -e "$options" | fuzzel --dmenu --prompt="Power: ")

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Suspend) systemctl suspend ;;
    Logout) loginctl terminate-user $USER ;;
    Lock) swaylock ;; # or your lock command
esac
