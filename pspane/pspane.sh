#!/bin/bash

tmux splitw -p 30 -h -t $1 "source ~/.config/dotfiles/venv/bin/activate && python ~/dotfiles/pspane/pspane.py $2 $1"
