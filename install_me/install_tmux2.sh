#!/bin/bash

# Navigate to the tmux source directory
cd ~/dotfiles/tmux || { echo "tmux source directory not found"; exit 1; }

# Create the build directory if it doesn't exist
mkdir -p ~/dotfiles/build

# Run the autogen script if it exists
if [ -f autogen.sh ]; then
  ./autogen.sh
fi

# Configure the build with the specified prefix
./configure --prefix="$HOME/dotfiles/build"

# Compile the source code
make

# Install tmux to the specified prefix
make install

echo "tmux has been compiled and installed to $HOME/dotfiles/build"
