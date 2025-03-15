#!/bin/bash

PREFIX="$HOME/dotfiles/build"
cd ~/dotfiles/neovim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$PREFIX" || exit 255
make install
echo "Neovim has been compiled and installed to $PREFIX"
