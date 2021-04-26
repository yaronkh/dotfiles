#!/bin/bash

tmux splitw -p 30 -h -t $1 "source ~/dotfiles/.env/bin/activate && python ~/dotfiles/vimmux/vimmux.py move $1"
