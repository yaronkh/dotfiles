#!/bin/bash

tmux splitw -p 30 -h -t $1 "python ~/dotfiles/pspane/pspane.py $2 $1"
