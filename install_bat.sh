#!/bin/bash

cd bat || exit 255
[ -d bat/.git ] || git clone https://github.com/sharkdp/bat.git
cd bat || exit 255
version=$(git tag | sort -V | tail -1)
git reset --hard "${version}" || exit 1
cd ../
cargo install --locked --root ~/dotfiles/build bat
