#!/bin/bash
vim_server=$(tmux show -v @vim_server)
nvr --servername $vim_server --remote-send ":call CaptureLastIpytTb()<CR>"

