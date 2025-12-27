#!/bin/bash
# ~/.local/bin/bookmark-menu

bookmarks="GitHub|https://github.com
Gmail|https://mail.google.com
YouTube|https://youtube.com
Reddit|https://reddit.com
Documentation|https://docs.example.com"

chosen=$(echo "$bookmarks" | fuzzel --dmenu --prompt="Open: " | cut -d'|' -f2)

[ -n "$chosen" ] && xdg-open "$chosen"
