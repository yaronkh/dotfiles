#!/usr/bin/env bash

if command -v tmux > /dev/null; then
        ver=$(tmux -V | tr -d -c 0-9\.)
        if (( $(echo "$ver >= 3.1" | bc -l) )); then
                echo "tmux already installed"
                exit 0
        fi
fi
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y gcc
sudo apt-get install -y autotools-dev
sudo apt-get install -y automake
sudo apt-get install -y libncurses5-dev libncursesw5-dev

if ! [ -d ~/tmp ]; then mkdir ~/tmp; fi
cd ~/tmp || die "cannot chdir to ~/tmp"

git clone https://github.com/tmux/tmux.git || die "cannot clone tmux source"

cd tmux
git checkout master || die "cannot change to tmux master branch"
sh autogen.sh || die "cannot prepare compilation files"
./configure && make -j || die "tmux compilation failed"
sudo make install || die "tmux installation problem"

if ! [ -f ~/.tmux.conf ];then
        cp ~/dotfiles/tmux.conf ~/.tmux.conf || die "could deploy .tmux.conf"
else
        if ! grep -q dotfiles/tmux_impl.conf; then
                cat ~/dotfiles/tmux.conf >> ~/.tmux.conf || die "could not prepare .tmux.conf"
        fi
fi
