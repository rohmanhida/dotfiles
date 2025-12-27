#!/bin/bash
# ~/.local/bin/emoji-picker

# Simple emoji list (you can expand this)
emojis="😀 Grinning Face
😂 Face with Tears of Joy
❤️ Red Heart
👍 Thumbs Up
🔥 Fire
✨ Sparkles
🎉 Party Popper
💯 Hundred Points
🚀 Rocket
📱 Mobile Phone"

chosen=$(echo "$emojis" | fuzzel --dmenu --prompt="Emoji: " | cut -d' ' -f1)

# Copy to clipboard
[ -n "$chosen" ] && echo -n "$chosen" | wl-copy
