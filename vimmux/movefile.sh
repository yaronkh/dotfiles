#!/bin/bash

tmux splitw -p 30 -h -t $1 "python ~/dotfiles/vimmux/vimmux.py move $1"
