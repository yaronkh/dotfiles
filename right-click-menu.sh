#!/bin/bash

# Get the current pane id
pane_id="$1"

# Read the mouse event information
IFS=',' read -r _ _ _ _ _ pane_id mouse_x mouse_y < <(tmux display -p "#{mouse_event}")

# Display a custom menu
tmux display-menu -t "$pane_id" -x "$mouse_x" -y "$mouse_y" \
    "Swap Pane" "" "swap-pane" \
    "Kill Pane" "" "kill-pane" \
    "Custom Option" "" "display-message 'You selected the custom option'"
