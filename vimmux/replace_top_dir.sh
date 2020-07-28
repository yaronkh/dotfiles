#!/bin/bash

PACK_DIR_RE1='\/site-packages\/'
PACK_DIR_RE2='File ".*"'
process_line(){
    PACK_DIR_RE=$1
    line=$2
    if echo "$line" | grep -Eq "$PACK_DIR_RE"; then
        rel_fn=$(echo "$line" | sed -E "s/.*$PACK_DIR_RE/src\//")
        stripped_fn=$( echo "$rel_fn" | sed 's/.*\(src\/[^: ]*\).*/\1/')
        if [ -f "$stripped_fn" ]; then
            echo "$rel_fn"
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

while IFS= read -r line; do
    line=$(echo "$line" | sed 's/^\[.*\]//')
    process_line "$PACK_DIR_RE1" "$line" || echo "$line"
done





