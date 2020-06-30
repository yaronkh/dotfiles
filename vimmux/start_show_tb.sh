#!/bin/bash

PANE_ID=$1

pane_data=$(tmux capture-pane -S - -p -t $PANE_ID)
num_lines=$(echo "$pane_data" | wc -l)
last_entry_line=$(echo "$pane_data" | grep -n ' Traceback ' | tail -1 | cut -d: -f1 )
from_line=$(echo "$num_lines-$last_entry_line" | bc)
echo "$pane_data" | tail -$from_line | awk '/\-+>/ { print ff ":" $2} /^(\/[^\/]+)+\.py in / { ff = $1}' 1>&2





