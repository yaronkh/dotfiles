#!/bin/bash

PACK_DIR_RE='\/site-packages\/'

while IFS= read -r line; do
    if echo "$line" | grep -Eq "$PACK_DIR_RE"; then
        rel_fn=$(echo "$line" | sed -E "s/.*$PACK_DIR_RE/src\//")
        stripped_fn=$( echo "$rel_fn" | sed 's/.*\(src\/[^: ]*\).*/\1/')
        if [ -f "$stripped_fn" ]; then
            echo "$rel_fn"
        else
            echo "$line"
        fi
    else
        echo $line
    fi
done





