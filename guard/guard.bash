#!/bin/bash

printf '%s\n' '
        .-"""-.
       / .===. \
       \/ 6 6 \/
       ( \___/ )
  _ooo__\_____/______
 /                   \
| I will alarm you   |
 \_______________ooo_/
        |  |  |
        |_ | _|
        |  |  |
        |__|__|
        /- | -\
       (__/ \__)
'
comname=$(ps -f --ppid $2 -eo comm | tail -1)
if [[ "$comname" == ssh* ]]; then
    echo -e "\e[1;31mATTEMPT TO WATCH SSH\e[0m"
fi

while true; do
    lines=$(ps -f --ppid $2 | wc -l)
    if [ "$lines" -le 1 ]; then
        tput bel
        echo "ring ring"
        sleep 1
        exit 0
    fi
    sleep 1
done
