#!/bin/sh
# Script to set up the layout

# Switch to workspace 1
hyprctl dispatch workspace 1

# Wait a moment for windows to be ready
sleep 0.5

# Set HELLDIVERS 2 to specific size and position (16:9 ratio)
# hyprctl dispatch resizewindowpixel exact 960 540,class:steam_app_553850
# hyprctl dispatch movewindowpixel exact 0 0,class:steam_app_553850

# Move Zen browser to fill remaining space
hyprctl dispatch movewindowpixel exact 1920 0,class:zen
hyprctl dispatch resizewindowpixel exact 640 1080,class:zen  # Negative values resize from right edge
