#!/bin/bash
function get_tmux_opt {
  tmux show -v "@$1_$2"
}

function set_tmux_opt {
    tmux set -q "@$1_$2" "$3"
}


