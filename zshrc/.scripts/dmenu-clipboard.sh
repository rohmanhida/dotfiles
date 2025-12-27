#!/bin/bash
# ~/.local/bin/clipboard-menu

cliphist list | fuzzel --dmenu --prompt="Clipboard: " | cliphist decode | wl-copy
