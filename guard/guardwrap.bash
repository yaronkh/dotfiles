#!/bin/bash

set -e

tmux splitw -l 22 -h -t $1 "/bin/bash ~/dotfiles/guard/guard.bash $1 $2"
tmux select-pane -t $1
