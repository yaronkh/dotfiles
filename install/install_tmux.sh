#!/usr/bin/env bash

TMUX_VER=3.2
STUFF_DIR=~/stuff
SOURCE_DIR=$STUFF_DIR/tmux

die() {
  echo $1
  exit 255
}

if command -v tmux > /dev/null; then
        ver=$(tmux -V | tr -d -c 0-9\.)
        if (( $(echo "$ver >= 3.1" | bc -l) )); then
                echo "tmux already installed"
                exit 0
        fi
fi
sudo apt-get update
sudo apt-get install -y pkg-config
sudo apt-get install -y build-essential
sudo apt-get install -y gcc
sudo apt-get install -y bison
sudo apt-get install -y libevent-dev
sudo apt-get install -y autotools-dev
sudo apt-get install -y automake
sudo apt-get install -y libncurses5-dev libncursesw5-dev

pyenv activate nvim # it is assumed that neovim is installed
pip install curses-menu
pip install psutil
pip install curses-util

if ! [ -d "$STUFF_DIR" ]; then mkdir -p "$STUFF_DIR"; fi
cd "$STUFF_DIR" || die "cannot chdir to $STUFF_DIR"
if ! [ -d "$SOURCE_DIR" ]; then
	git clone https://github.com/tmux/tmux.git || die "cannot clone tmux source"
	cd tmux
else
	cd tmux
	git fetch || die "cannot fetch updates from tmux"
fi

git checkout "$TMUX_VER" || die "cannot change to tmux master branch"
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
