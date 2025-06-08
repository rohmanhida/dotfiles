#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title kitty maximized
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName dev utils

# Documentation:
# @raycast.description kitty in maximized window
# @raycast.author rohmanhida

kitty --directory $HOME --start-as=maximized
