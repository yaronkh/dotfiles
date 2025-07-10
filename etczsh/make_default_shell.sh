#!/bin/bash

current_shell=$( basename "$(finger -l 2>/dev/null | grep -o "Shell:.*" | sed "s/Shell://")")

if [ "$current_shell" != "zsh" ]; then
    chsh -s "$(which zsh)"
fi
