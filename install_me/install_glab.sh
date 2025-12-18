#!/bin/bash

pushd tools/tools/cli
make
cp bin/glab ~/dotfiles/build/bin/
