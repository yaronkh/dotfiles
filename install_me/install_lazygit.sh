#!/bin/bash

pushd /tmp || exit 1
mkdir lazygit_$$
pushd lazygit_$$ || exit 1

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit -D -t "${HOME}/dotfiles/build/bin"

popd || exit 1
rm -rf lazygit_$$
popd || exit 1
