#!/bin/bash

tmux splitw -p 30 -h -t $1 "while ps $2 > /dev/null ; do tput clear; pstree $2; sleep 2; done"
