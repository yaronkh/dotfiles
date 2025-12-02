#!/bin/bash

pushd /tmp || exit 1

wget https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz

tar xvfpz ookla-speedtest-1.2.0-linux-x86_64.tgz

cp ./speedtest "$HOME/dotfiles/build/bin/"
