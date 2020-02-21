#!/bin/bash
function get_tmux_opt {
  tmux show -v "@$1_$2"
}

function set_tmux_opt {
    tmux set -q "@$1_$2" "$3"
}

if [ "$2" = "toggle" ]; then
  val=$(get_tmux_opt hide_border $1)
  if [ -z "$val" ]; then
    set_tmux_opt hide_border $1 "y"
  else
    set_tmux_opt hide_border $1 ""
  fi
fi

#echo "get_tmux_opt hide_border $1-->$(get_tmux_opt hide_border $1)" >> /tmp/yaron.$1
if [ ! -z "$(get_tmux_opt hide_border $1)" ]; then
#        echo "hide" >> /tmp/yaron.$1
        tmux set-option -t $1 pane-border-status off
        tmux set status off
else
#        echo "show" >> /tmp/yaron.$1
        tmux set-option -t $1 pane-border-status bottom
        tmux set status on
fi
