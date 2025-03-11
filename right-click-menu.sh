#!/bin/bash

# Get the current pane id
pane_id="$1"

# Display a custom menu
tmux display-menu -t $pane_id -x R -y P \
    "Swap Pane" "" "swap-pane" \
    "Kill Pane" "" "kill-pane" \
    "Custom Option" "" "display-message 'You selected the custom option'"
