#!/bin/bash

# Navigate to the tmux source directory
cd ~/dotfiles/tmux || { echo "tmux source directory not found"; exit 1; }

# Run the autogen script if it exists
if [ -f autogen.sh ]; then
  ./autogen.sh || exit 255
fi

# Configure the build with the specified prefix
./configure --prefix="$HOME/dotfiles/build" || exit 255

# Compile the source code
make || exit 255

# Install tmux to the specified prefix
make install || exit 255

echo "tmux has been compiled and installed to $HOME/dotfiles/build"
