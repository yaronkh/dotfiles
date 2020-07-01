#!/bin/bash

PANE_ID=$1
PACK_DIR_RE="^\/.*\/site-packages\/"

pane_data=$(tmux capture-pane -S - -p -t $PANE_ID)
num_lines=$(echo "$pane_data" | wc -l)
last_entry_line=$(echo "$pane_data" | grep -n ' Traceback ' | tail -1 | cut -d: -f1 )
from_line=$(echo "$num_lines-$last_entry_line" | bc)
data=$(echo "$pane_data" | tail -$from_line | awk '/\-+>/ { print ff ":" $2} /^(\/[^\/]+)+\.py in / { ff = $1}')
for fn in $data; do
    #echo "testing $fn"
    if echo $fn | egrep -Eq "$PACK_DIR_RE"; then
        rel_fn=$(echo $fn | sed -E "s/$PACK_DIR_RE/src\//")
        #rel_fn="src/$rel_fn"
        stripped_rfn=$(echo $rel_fn | sed 's/:.*//')
        #echo "relfn=$stripped_rfn"
        if [ -f "$stripped_rfn" ]; then
            echo "$rel_fn" 1>&2
        else
            echo "$fn" 1>&2
        fi
    else
        echo $fn 1>&2
    fi
done





