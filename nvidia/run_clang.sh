#!/bin/bash

fn=$1
#g=$(echo $@ | grep -Eo '\-c [^ ]*' | cut -d ' ' -f2)
if [[ "$fn" =~ ^.*\/app\/.*$ ]]; then
        f="${fn}_gen_events.h"
        f=$(echo $f | sed 's@.*app/@@')
        dir=$(echo "$fn" | sed 's/\/app\/.*//')
        sub="app"
        cd "$dir/$sub"
        if [ -f "$f" ]; then
                md50=$(md5sum $f | cut -d ' ' -f 1)
        else
                md50=""
        fi
        CC=clang make $f
        md51=$(md5sum $f | cut -d ' ' -f 1)
        if [ "$md50" == "$md51" ]; then
                echo "Nothing to be done"
        fi
        echo -n 0
elif [[ "$fn" =~ ^.*\/nvmesh.kernel\/.*$ ]]; then
        dir=$(echo "$fn" | sed 's/\/nvmesh.kernel\/.*//')
        sub="nvmesh.kernel/clnt/block/unitest"
        f=traces_ids.c
        cd "$dir/$sub"
        md50=$(md5sum "gen_events.h" | cut -d ' ' -f 1)
        tr0 = $(md5sum "$f" | cut -d ' ' -f 1)
        if CC=clang make "$f"; then
                md51=$(md5sum "gen_events.h" | cut -d ' ' -f 1)
                tr1 = $(md5sum "$f" | cut -d ' ' -f 1)
                if [ "$md50" == "$md51" ] && [ "$tr0" == "$tr1" ]; then
                        echo "Nothing to be done"
                fi
                echo -n 0
        else
                echo -n 255
        fi
fi
