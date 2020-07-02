#!/bin/bash
vim_server=$(tmux show -v @vim_server)
PANE=$1
nvr --servername $vim_server --remote-send ":call CaptureLastIpytTb("\"$PANE\"")<CR>"

