#!/bin/bash
# ~/.local/bin/window-switcher

# Parse niri msg windows output
windows=$(niri msg windows | awk '
/^Window ID/ {
    id = $3
    gsub(/:/, "", id)
}
/^  Title:/ {
    title = $0
    gsub(/^  Title: "/, "", title)
    gsub(/"$/, "", title)
}
/^  App ID:/ {
    app_id = $0
    gsub(/^  App ID: "/, "", app_id)
    gsub(/"$/, "", app_id)
    printf "%s: %s [%s]\n", id, title, app_id
}
')

chosen=$(echo "$windows" | fuzzel --dmenu --prompt="Switch to: ")

if [ -n "$chosen" ]; then
    window_id=$(echo "$chosen" | cut -d: -f1 | tr -d ' ')
    niri msg action focus-window --id "$window_id"
fi
