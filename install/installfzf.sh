#!/usr/bin/env bash

function die(){
        echo "FATAL: $0"
        return 255
}


echo "****************installing fuzzy finder*****************"
if ! [ -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || die "cannot clone fzf"
        cd ~/.fzf
        ./install || die "cannot install fzf"
fi
if ! grep -q fzf.bash ~/.bashrc; then
        echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bashr" >> ~/.bashrc || die "cannot add fzf command to bashrc"
fi
