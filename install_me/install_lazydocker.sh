#!/bin/bash

pushd /tmp || exit 1
export DIR="$HOME/dotfiles/build/bin"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
popd || exit 1
