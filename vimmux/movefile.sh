#!/bin/bash

tmux splitw -p 30 -h -t $1 "bash -ic \"pyenv activate nvim > /dev/null 2>&1; exec python ~/dotfiles/vimmux/vimmux.py move $1\""
