#!/bin/bash

# echo "tmux splitw -p 30 -h -t $1 \"pyenv activate nvim > /dev/null 2>&1 && python ~/dotfiles/pspane/pspane.py $2 $1\"" > /tmp/yaron
# tmux splitw -p 30 -h -t $1 "bash -ic \"pyenv activate nvim > /dev/null 2>&1 ; exec python ~/dotfiles/pspane/pspane.py $2 $1 || sleep 10\""
tmux  display-popup -t $1 -T "Processes tree of pid $2" "bash -ic \"pyenv activate nvim > /dev/null 2>&1 ; exec python ~/dotfiles/pspane/pspane.py $2 $1 || sleep 10\""
exit 0
